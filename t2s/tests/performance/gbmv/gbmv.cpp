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
    #define P                         iii,       ii,      kk,      k,   i
    #define P_iii_minus_1             iii-1,     ii,      kk,      k,   i
    #define P_kk_minus_1_iii_plus_1   iii+1,     ii,      kk-1,    k,   i
    #define P_kk_minus_1_ii_plus_1    iii-III+1, ii+1,    kk-1,    k,   i
    #define P_Out_1                                       kk,      k,   i
    #define P_Out_2                   iii,       ii,               k,   i

    // Linearized addresses
    #define total_i         (iii + III * ii + III * II * i)
    #define total_k         (kk + KK * k)

    // Outer loop bounds, which are determined by input sizes
    #define I               (A.dim(1).extent() / (III * II))
    #define K               (A.dim(0).extent() / (KKK * KK))

    // Type of the data to process in C and T2S
    #define CTYPE float
    #define TTYPE Float(32)

    // Inputs
    Param<float> Alpha, Beta;
    ImageParam A("A", TTYPE, 2), X("X", TTYPE, 1), Y("Y", TTYPE, 1);

    // UREs
    Var iii("iii"), kk("kk"), ii("ii"), k("k"), i("i");
    URE uA("uA", TTYPE, {P}), uX("uX", TTYPE, {P}), uY("uY", TTYPE, {P}), uZ("uZ", TTYPE, {P});
    URE V_1("V_1"), V_2("V_2"), Out("Out");
    uA(P) = A(total_k, total_i);
    uX(P) = select(iii == 0, X(total_k), uX(P_iii_minus_1));
    uZ(P) = select(kk == 0 || (iii == III-1 && ii == II-1), 0,
                    select(iii == III-1, uZ(P_kk_minus_1_ii_plus_1),
                                         uZ(P_kk_minus_1_iii_plus_1))
                  ) + uA(P) * uX(P);
    V_1(P_Out_1) = select(iii == 0 && ii == 0, uZ(P));
    // V_2(P_Out_2) = select(kk == KK-1, uZ(P));

    // Put all the UREs inside the same loop nest of X.
    uA.merge_ures(uX, uZ, V_1);

    // Explicitly set the loop bounds
    uA.set_bounds(iii, 0, III)
      .set_bounds(ii,  0, II,  kk,  0, KK)
      .set_bounds(i,   0, I,   k,   0, K);
    V_1.set_bounds(kk, 0, KK);

    // Create a systolic array
    uA.space_time_transform(iii);

    // GPU can have many threads running in parallel.
#ifdef GPU
    uA.gpu_blocks(j, i).gpu_threads(jj, ii);
#endif

    // I/O network
    Stensor aLoader("aLoader", DRAM);
    A >> aLoader >> FIFO(256);

    Stensor xLoader("xLoader", DRAM), xFeeder("xFeeder", SRAM);
    X >> xLoader >> FIFO(256)
      >> xFeeder.scope(k) >> FIFO(256);

    Stensor unloader_1("unloader_1", DRAM), deserializer_1("deserializer_1");
    V_1 >> FIFO(256) >> unloader_1 >> deserializer_1(total_i);

    // Stensor unloader_2("unloader_2", DRAM), deserializer_2("deserializer_2");
    // V_2 >> FIFO(256) >> unloader_2 >> deserializer_2(total_i);

    // Compile the kernel to an FPGA bitstream, and expose a C interface for the host to invoke
    deserializer_1.compile_to_host("gbmv-interface", { A, X }, "gbmv", IntelFPGA);
    printf("Success\n");

    return 0;
}
