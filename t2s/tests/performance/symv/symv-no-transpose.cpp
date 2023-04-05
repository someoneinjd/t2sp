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
    #define P                 iii,   ii, kkk,       kk,      k,   i
    #define P_iii_minus_1     iii-1, ii, kkk,       kk,      k,   i
    #define P_kkk_minus_1     iii,   ii, kkk-1,     kk,      k,   i
    #define P_kk_minus_1      iii,   ii, kkk+KKK-1, kk-1,    k,   i
    #define P_k_minus_1       iii,   ii, kkk+KKK-1, kk+KK-1, k-1, i
    #define P_Out             iii,   ii,                          i

    // T Dependences
    #define P_T               kkk,   kk,   iii, ii, i, k
    #define P_T_kkk_minus_1   kkk-1, kk,   iii, ii, i, k
    #define P_T_kk                   kk,   iii, ii, i, k
    #define P_T_kk_minus_1           kk-1, iii, ii, i, k
    #define P_T_Out                        iii, ii, i, k
    #define P_R_k_minus_1                  iii, ii, i, k-1

    // Linearized addresses
    #define total_i           (iii + III * ii + III * II * i)
    #define total_k           (kkk + KKK * kk + KKK * KK * k)

    // Outer loop bounds, which are determined by input sizes
    #define I (A.dim(1).extent() / (III * II))
    #define K (A.dim(0).extent() / (KK))

    // Type of the data to process in C and T2S
    #define CTYPE float
    #define TTYPE Float(32)

    // Inputs
    ImageParam A("A", TTYPE, 2), X("X", TTYPE, 1);

    // UREs for original input
    Var kkk("kkk"), iii("iii"), kk("kk"), ii("ii"), k("k"), i("i");
    URE uA("uA", TTYPE, {P}), uX("uX", TTYPE, {P}), uZ("uZ", TTYPE, {P}), V("V");
    uA(P) = A(total_k, total_i);
    uX(P) = select(iii == 0, X(total_k), uX(P_iii_minus_1));
    uZ(P) = select(kkk == 0 && kk == 0 && k == i, 0,
                   select(kkk == 0,
                          select(kk == 0, uZ(P_k_minus_1), uZ(P_kk_minus_1)),
                          uZ(P_kkk_minus_1))
                  ) + uA(P) * uX(P);
    V(P_Out) = select(kkk == KKK-1 && kk == KK-1 && k == K-1, uZ(P));

    // Put all the UREs inside the same loop nest of X.
    uA.merge_ures(uX, uZ, V);

    // Explicitly set the loop bounds
    uA.set_bounds(kkk, 0, KKK,    iii, 0, III)
      .set_bounds(kk,  0, KK,     ii,  0, II)
      .set_bounds(k,   i, K - i,  i,   0, I);

    // Create a systolic array
    uA.space_time_transform(iii);

    // UREs for symmetrical position
    URE uA_T("uA_T", TTYPE, {P_T}), uX_T("uX_T", TTYPE, {P_T}), uZ_T("uZ_T", TTYPE, {P_T}), Z_T("Z_T");
    uA_T(P_T) = A(total_k, total_i);
    uX_T(P_T) = X(total_k);
    uZ_T(P_T) = select(kkk == 0, 0, uZ_T(P_T_kkk_minus_1))
                       + uA_T(P_T) * uX_T(P_T);
    Z_T(P_T_kk) = select(kkk == KK-1, uZ_T(P_T));

    // Put all the UREs inside the same loop nest of X.
    uA_T.merge_ures(uX_T, uZ_T, Z_T);

    // Explicitly set the loop bounds
    uA_T.set_bounds(kkk, 0, III,  iii, 0, KKK)
        .set_bounds(kk,  0, II,   ii,  0, KK)
        .set_bounds(k,   0, K,    i,   k, I - k);

    // Create a systolic array
    uA_T.space_time_transform(kkk);

    // UREs for kk reduction
    URE uZ_T_kk("uZ_T_kk", TTYPE, {P_T_kk}), V_T("V_T");
    uZ_T_kk(P_T_kk) = select(kk == 0, 0, uZ_T_kk(P_T_kk_minus_1)) + Z_T(P_T_kk);
    V_T(P_T_Out) = select(kk == KK-1, uZ_T_kk(P_T_kk));

    // Put all the UREs inside the same loop nest of X.
    uZ_T_kk.merge_ures(V_T);

    // Explicitly set the loop bounds
    uZ_T_kk.set_bounds(iii, 0, KKK)
           .set_bounds(kk,  0, II,   ii,  0, KK)
           .set_bounds(k,   0, K,    i,   k, I - k);

    // Host processing
    Func uR("uR", TTYPE, {P_T_Out}, Place::Host), W("W");
    uR(P_T_Out) = select(k == 0, 0, uR(P_R_k_minus_1)) + V_T(P_T_Out);
    W(P_Out) = select(k == K-1, uR(P_T_Out));

    Func Out("Out");
    Out(P_Out) = V(P_Out) + W(P_Out);

    uR.merge_ures(W);
    uR.set_bounds(k, 0, K)
      .set_bounds(ii, 0, II, i, 0, I);
    Out.set_bounds(ii, 0, II, i, 0, I);

    // Input path of matrix A
    Func ASerializer("ASerializer", Place::Host), ALoader("ALoader", Place::Device);
    uA.isolate_producer_chain(A, ASerializer, ALoader);
    ASerializer.set_bounds(k, 0, K);

    // Input path of vector B
    Func XSerializer("XSerializer", Place::Host), XLoader("XLoader", Place::Device), XFeeder("XFeeder", Place::Device);
    uA.isolate_producer_chain(X, XSerializer, XLoader, XFeeder);
    XFeeder.buffer(XLoader, k);
    XSerializer.set_bounds(k, 0, K).remove(iii, ii, i);
    XLoader.remove(iii, ii);

    // Input path of matrix A
    // TODO: reuse ALoader
    Func ALoader_T("ALoader_T", Place::Device);
    uA_T.isolate_producer_chain(A, ALoader_T);

    // Input path of vector B
    Func XSerializer_T("XSerializer_T", Place::Host), XLoader_T("XLoader_T", Place::Device), XFeeder_T("XFeeder_T", Place::Device);
    uA_T.isolate_producer_chain(X, XSerializer_T, XLoader_T, XFeeder_T);
    XFeeder_T.buffer(XLoader_T, i);
    XSerializer_T.set_bounds(k, 0, K).remove(iii, ii, i);
    XLoader_T.remove(iii, ii);

    Func deserializer("deserializer", Place::Host), unloader("unloader", Place::Device);
    V.isolate_consumer_chain(unloader, deserializer);

    Func deserializer_T("deserializer_T", Place::Host), unloader_T("unloader_T", Place::Device);
    V_T.isolate_consumer_chain(unloader_T, deserializer_T);

    XLoader_T.vectorize(kkk);
    XFeeder_T.vectorize(kkk);
    uA_T.vectorize(kkk);

    // Compile the kernel to an FPGA bitstream, and expose a C interface for the host to invoke
    Target acc = get_host_target();
    acc.set_feature(Target::IntelFPGA);
    acc.set_feature(Target::EnableSynthesis);
    Out.compile_to_host("trmv-interface", { A, X }, "trmv", acc);
    printf("Success\n");
    return 0;
}
