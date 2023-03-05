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
    #define P               iii,   ii, kk,      k,   i
    #define P_iii_minus_1   iii-1, ii, kk,      k,   i
    #define P_kk_minus_1    iii,   ii, kk-1,    k,   i
    #define P_k_minus_1     iii,   ii, kk+KK-1, k-1, i
    #define P_out           iii,   ii,               i

    #define P_T             iii,   ii, kk,      i,   k
    #define P_T_iii_minus_1 iii-1, ii, kk,      i,   k
    #define P_T_kk_minus_1  iii,   ii, kk-1,    i,   k
    #define P_s0            iii,   ii,          i,   k
    #define P_T_k_minus_1   iii,   ii,          i,   k-1

    // Linearized addresses
    #define lin_k           (kk + KK*k)
    #define lin_i           (iii + III*ii + III*II*i)

    // Type of the data to process in C and T2S
    #define CTYPE float
    #define TTYPE Float(32)

    // Inputs
    ImageParam A("A", TTYPE, 2), x("x", TTYPE, 1), y(Float(32), 1);
    Param<float> alpha, beta;

    // UREs
    Var kk("kk"), iii("iii"), ii("ii"), k("k"), i("i");
    URE UpFx("UpFx", TTYPE, {P}), LowFx("LowFx", TTYPE, {P_T});
    URE UpMV("UpMV", TTYPE, {P}), UpMVOut("UpMVOut", TTYPE, {P_out});
    URE LowMV_s0("LowMV_s0", TTYPE, {P_T}), LowMVOut_s0("LowMVOut_s0", TTYPE, {P_s0});
    URE LowMV_s1("LowMV_s1", TTYPE, {P_s0}), LowMVOut_s1("LowMVOut_s1", TTYPE, {P_out});
    URE Add("Add", TTYPE, {P_out});

    UpFx(P) = select(iii == 0, x(lin_k), UpFx(P_iii_minus_1));
    UpMV(P) = select(kk == 0 && k == i, 0,
                    select(kk == 0, UpMV(P_k_minus_1), UpMV(P_kk_minus_1))
                    ) + A(lin_k, lin_i) * UpFx(P);
    UpMVOut(P_out) = select(kk == KK-1 && k == K-1, UpMV(P));

    LowFx(P_T) = select(iii == 0, x(lin_k), LowFx(P_T_iii_minus_1));
    LowMV_s0(P_T) = select(kk == 0, 0, LowMV_s0(P_T_kk_minus_1)
                    ) + A(lin_k, lin_i) * LowFx(P_T);
    LowMVOut_s0(P_s0) = select(kk == KK-1, LowMV_s0(P_T));
    LowMV_s1(P_s0) = select(k == 0, 0, LowMV_s1(P_T_k_minus_1)) + LowMVOut_s0(P_s0);
    LowMVOut_s1(P_out) = select(k == i-1, LowMV_s1(P_s0));

    Add(P_out) = alpha*select(i == 0, UpMVOut(P_out), UpMVOut(P_out) + LowMVOut_s1(P_out)) + beta*y(lin_i);

    UpFx.merge_ures(UpMV, UpMVOut);
    UpFx.set_bounds(iii, 0, III)
        .set_bounds(ii,  0, II,  kk,  0, KK)
        .set_bounds(i,   0, I,   k,   i, K-i);
    UpFx.space_time_transform(iii);
    LowFx.merge_ures(LowMV_s0, LowMVOut_s0);
    LowFx.set_bounds(iii, 0, III)
         .set_bounds(ii,  0, II,   kk,  0, KK)
         .set_bounds(i,   k, I-k,  k,   0, K);
    LowFx.space_time_transform(iii);
    LowMV_s1.merge_ures(LowMVOut_s1);
    LowMV_s1.set_bounds(iii, 0, III, ii, 0, II)
            .set_bounds(i,   k, I-k, k,  0, K);
    LowMV_s1.space_time_transform(iii);
    Add.set_bounds(iii, 0, III)
       .set_bounds(ii,  0, II)
       .set_bounds(i,   0, I);
    // Add.space_time_transform(iii);

    // Input path of matrix A
    Func A_serializer("A_serializer", Place::Host), DA("DA", Place::Device), SA("SA", Place::Device);
    UpFx.isolate_producer_chain(A, A_serializer, DA);
    LowFx.isolate_producer_chain(A, DA, SA);
    A_serializer.bound_storage(k, 0, K/2+1);
#ifdef S10
    A_serializer.partition(A, DA, iii, 4);
#else
    A_serializer.partition(A, DA, iii, 2);
#endif
    SA.scatter(DA, iii, ScatterStrategy::ForwardVector);
    SA.addressable_buffer(DA, i, {iii+III*ii, kk}, {kk, iii+III*ii});
    DA.min_depth(256);
    SA.min_depth(256);

    // Input path of vector X
    Func DX_Up("DX_Up", Place::Device), SX_Up("SX_Up", Place::Device);
    Func DX_Low("DX_Low", Place::Device), SX_Low("SX_Low", Place::Device);
    UpFx.isolate_producer_chain(x, DX_Up, SX_Up);
    LowFx.isolate_producer_chain(x, DX_Low, SX_Low);
    SX_Up.buffer(DX_Up, k);
    DX_Up.remove(ii, iii);
    SX_Low.buffer(DX_Low, i);
    DX_Low.remove(ii, iii);
    DX_Up.min_depth(256);
    SX_Up.min_depth(256);
    DX_Low.min_depth(256);
    SX_Low.min_depth(256);

    // Input path of vector Y
    Func Y_serializer("Y_serializer", Place::Host), DY("DY", Place::Device);
    Add.isolate_producer_chain(y, Y_serializer, DY);
    DY.min_depth(256);

    // Output path of vector Z
    Func deserializer("deserializer", Place::Host), DZ("DZ", Place::Device);
    Add.isolate_consumer_chain(DZ, deserializer);
    UpMVOut.min_depth(256);
    LowMVOut_s0.min_depth(256);
    LowMVOut_s1.min_depth(256);
    Add.min_depth(256);

    // Compile the kernel to an FPGA bitstream, and expose a C interface for the host to invoke
    Target acc = get_host_target();
    acc.set_feature(Target::IntelFPGA);
    acc.set_feature(Target::EnableSynthesis);
    deserializer.compile_to_host("symv-interface", { A, x, y, alpha, beta }, "symv", acc);
    printf("Success\n");
    return 0;
}
