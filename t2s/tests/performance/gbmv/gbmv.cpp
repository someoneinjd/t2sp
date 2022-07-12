/*******************************************************************************
* Copyright 2021 Intel Corporation
*
* Licensed under the BSD-2-Clause Plus Patent License (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* https://opensource.org/licenses/BSDplusPatent
*
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions
* and limitations under the License.
*
*
* SPDX-License-Identifier: BSD-2-Clause-Patent
*******************************************************************************/
#include "Halide.h"
#include "util.h"

// Constant parameters (inner loop bounds) of the design
#include "const-parameters.h"

using namespace Halide;

int main()
{
    // Dependences
    #define P                          kkk,       iii,       ii,      kk,      k,   i
    #define P_kkk_minus_1              kkk-1,     iii,       ii,      kk,      k,   i
    #define P_kkk_minus_1_iii_minus_1  kkk-1,     iii-1,     ii,      kk,      k,   i
    #define P_kkk_minus_1_ii_minus_1   kkk-1,     iii+III-1, ii-1,    kk,      k,   i
    #define P_kkk_minus_1_i_minus_1    kkk-1,     iii+III-1, ii+II-1, kk,      k,   i-1
    #define P_kk_minus_1               kkk+KKK-1, iii,       ii,      kk-1,    k,   i
    #define P_k_minus_1                kkk+KKK-1, iii,       ii,      kk+KK-1, k-1, i
    #define P_iii_minus_1              kkk,       iii-1,     ii,      kk,      k,   i
    #define P_ii_minus_1               kkk,       iii+III-1, ii-1,    kk,      k,   i
    #define P_i_minus_1                kkk,       iii+III-1, ii+II-1, kk,      k,   i-1
    #define P_Out                                 iii,       ii,                    i

    // Linearized addresses
    #define total_i         (iii + III * ii + III * II * i)
    #define total_k         (kkk + KKK * kk + KKK * KK * k)
    #define total_j         (total_i - total_k)

    // Outer loop bounds, which are determined by input sizes
    #define I               ((A.dim(0).extent() + A.dim(1).extent() + III * II - 1) / (III * II))
    #define TOTAL_J         A.dim(0).extent()
    #define K               (A.dim(1).extent() / (KKK * KK))

    #define oob             (total_j < 0 || total_j >= TOTAL_J || total_k > A.dim(1).extent())

    // Type of the data to process in C and T2S
    #define CTYPE float
    #define TTYPE Float(32)

    // Inputs
    Param<float> Alpha, Beta;
    ImageParam A("A", TTYPE, 2), X("X", TTYPE, 1), Y("Y", TTYPE, 1);

    // UREs
    Var kkk("kkk"), iii("iii"), kk("kk"), ii("ii"), k("k"), i("i");
    URE uA("uA", TTYPE, {P}), uX("uX", TTYPE, {P}), uY("uY", TTYPE, {P}), uZ("uZ", TTYPE, {P}), V("V"), Out("Out");
    uA(P) = select(total_k > A.dim(1).extent(), 0, A(total_j, total_k));
    uX(P) = select(kkk == 0 || iii == 0, 
                    X(total_j),
                    uX(P_kkk_minus_1_iii_minus_1));
    uZ(P) = select(total_k == 0, 0,
                                 select(kkk == 0, select(kk == 0, uZ(P_k_minus_1),
                                                                  uZ(P_kk_minus_1)), 
                                                  uZ(P_kkk_minus_1)))
            + uA(P) * uX(P);
    V(P_Out) = select(kkk == KKK-1 && kk == KK-1 && k == K-1, uZ(P));
    Out(P_Out) = V(P_Out) * Alpha + Y(total_i) * Beta;

    // Put all the UREs inside the same loop nest of X.
    uA.merge_ures(uX, uZ, V);

    // Explicitly set the loop bounds
    uA.set_bounds(iii, 0, III, kkk, 0, KKK)
      .set_bounds(ii,  0, II,  kk,  0, KK)
      .set_bounds(i,   0, I,   k,   0, K);
    Out.set_bounds(iii, 0, III)
       .set_bounds(ii,  0, II)
       .set_bounds(i,   0, I);

    // Create a systolic array
    uA.space_time_transform(iii);
    // uA.vectorize(kkk);

    // GPU can have many threads running in parallel.
#ifdef GPU
    uA.gpu_blocks(j, i).gpu_threads(jj, ii);
#endif

    // I/O network
    // Stensor aLoader("aLoader", DRAM), aFeeder("aFeeder", SRAM);
    // Stensor xLoader("xLoader", DRAM), xFeeder("xFeeder", SRAM);
    // Stensor yLoader("yLoader", DRAM), yFeeder("yFeeder", SRAM);
    // Stensor collector("collector", REG), unloader("unloader", DRAM), deserializer("deserializer");
    // A >> aLoader.out(kkk)                >> FIFO(256)
    //   >> aFeeder.scope(k)                >> FIFO(256);
    // X >> xLoader.out(kkk)                >> FIFO(256)
    //   >> xFeeder.scope(k)                >> FIFO(256);
    // Y >> yLoader.out(kkk)                >> FIFO(256)
    //   >> yFeeder.scope(k)                >> FIFO(256);
    // Out >> collector.scope(iii)          >> FIFO(256)
    //     >> unloader >> deserializer(total_i);
    // deserializer.compile_to_host("gbmv2-interface", { Alpha, Beta, A, X, Y }, "gbmv", IntelFPGA);
    Func aSerializer("aSerializer", Place::Host), aLoader("aLoader", Place::Device), aFeeder("aFeeder", Place::Device);
    Func xSerializer("xSerializer", Place::Host), xLoader("xLoader", Place::Device), xFeeder("xFeeder", Place::Device);
    Func ySerializer("ySerializer", Place::Host), yLoader("yLoader", Place::Device), yFeeder("yFeeder", Place::Device);
    Func drainer("drainer", Place::Device), collector("collector", Place::Device), unloader("unloader", Place::Device);
    Func deserializer("deserializer", Place::Host);

    uA.isolate_producer_chain(A, aSerializer, aLoader, aFeeder);
    uA.isolate_producer_chain(X, xSerializer, xLoader, xFeeder);
    Out.isolate_producer_chain(Y, ySerializer, yLoader, yFeeder);

    Out.isolate_consumer_chain(drainer, collector, unloader, deserializer);
    Target acc = get_host_target();
    acc.set_feature(Target::IntelFPGA);
    acc.set_feature(Target::EnableSynthesis);
    deserializer.compile_to_host("gbmv-interface", { Alpha, Beta, A, X, Y }, "gbmv", acc);
    printf("Success\n");

    return 0;
}
    // uX(P) = select(total_k == 0, X(total_i),
    //                              select(kkk == 0, select(kk == 0, uX(P_i_minus_1),
    //                                                               uX(P_ii_minus_1)),
    //                                               uX(P_iii_minus_1)));
    // uX(P) = select(oob, 0,
    //             select(total_k == 0, 
    //                 X(total_i),
    //                 select(total_j == 0, 
    //                     select(total_k == 0,
    //                         0,
    //                         select(kkk == 0, 
    //                             select(kk == 0,
    //                                 uX(P_k_minus_1),
    //                                 uX(P_kk_minus_1)), 
    //                             uX(P_kkk_minus_1)
    //                         )
    //                     ),
    //                     select(total_i == 0,
    //                         0,
    //                         select(iii == 0, 
    //                             select(ii == 0,
    //                                 uX(P_i_minus_1),
    //                                 uX(P_ii_minus_1)), 
    //                             uX(P_iii_minus_1)
    //                         )
    //                     )
    //                 )
    //             )
    //         );
    // uX(P) = select(total_k == 0,
    //             X(total_i),
    //             select(kkk == 0, 
    //                 select(kk == 0, 
    //                     select(iii == 0, 
    //                         select(ii == 0,
    //                             uX(P_k_minus_1_i_minus_1),
    //                             uX(P_k_minus_1_ii_minus_1)),
    //                         uX(P_k_minus_1_iii_minus_1)),
    //                     select(iii == 0, 
    //                         select(ii == 0, 
    //                             uX(P_kk_minus_1_i_minus_1),
    //                             uX(P_kk_minus_1_ii_minus_1)),
    //                         uX(P_kk_minus_1_iii_minus_1))),
    //                 select(iii == 0, 
    //                     select(ii == 0, 
    //                         uX(P_kkk_minus_1_i_minus_1),
    //                         uX(P_kkk_minus_1_ii_minus_1)),
    //                     uX(P_kkk_minus_1_iii_minus_1))));
