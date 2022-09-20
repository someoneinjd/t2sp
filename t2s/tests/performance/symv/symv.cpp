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
    #define P                 iii,   ii, kk,      k,   i
    #define P_iii_minus_1     iii-1, ii, kk,      k,   i
    #define P_kk_minus_1      iii,   ii, kk-1,    k,   i
    #define P_k_minus_1       iii,   ii, kk+KK-1, k-1, i
    #define P_Out             iii,   ii,               i

    // T Dependences
    #define P_T               iii,   ii, kk,      i,   k
    #define P_T_iii_minus_1   iii-1, ii, kk,      i,   k
    #define P_T_kk_minus_1    iii,   ii, kk-1,    i,   k
    #define P_T_Out           iii,   ii,          i,   k

    #define P_R_k_minus_1     iii,   ii,          i,   k-1

    // Linearized addresses
    #define total_i           (iii + III * ii + III * II * i)
    #define total_k           (kk + KK * k)

    // Outer loop bounds, which are determined by input sizes
    #define I (A.dim(1).extent() / (III * II))
    #define K (A.dim(0).extent() / (KK))

    // Type of the data to process in C and T2S
    #define CTYPE float
    #define TTYPE Float(32)

    // Inputs
    ImageParam A("A", TTYPE, 2), X("X", TTYPE, 1);

    // UREs
    Var iii("iii"), kk("kk"), ii("ii"), k("k"), i("i");
    URE uA("uA", TTYPE, {P}), uX("uX", TTYPE, {P}), uZ("uZ", TTYPE, {P}), V("V");
    uA(P) = A(total_k, total_i);
    uX(P) = select(iii == 0, X(total_k), uX(P_iii_minus_1));
    uZ(P) = select(kk == 0 && k == i, 0,
                   select(kk == 0, uZ(P_k_minus_1), uZ(P_kk_minus_1))
                  ) + uA(P) * uX(P);
    V(P_Out) = select(kk == KK-1 && k == K-1, uZ(P));

    URE uA_T("uA_T", TTYPE, {P_T}), uX_T("uX_T", TTYPE, {P_T}), uZ_T("uZ_T", TTYPE, {P_T}), V_T("V_T");
    uA_T(P_T) = A(total_k, total_i);
    uX_T(P_T) = select(iii == 0, X(total_k), uX_T(P_T_iii_minus_1));
    uZ_T(P_T) = select(kk == 0, 0, uZ_T(P_T_kk_minus_1)
                      ) + uA_T(P_T) * uX_T(P_T);
    V_T(P_T_Out) = select(kk == KK-1, uZ_T(P_T));

    Func uR("uR", TTYPE, {P_T_Out}, Place::Host), W("W");
    uR(P_T_Out) = select(k == 0, 0, uR(P_R_k_minus_1))
                    + select(i == k, 0, V_T(P_T_Out));
    W(P_Out) = select(k == K-1, uR(P_T_Out));

    Func Out("Out");
    Out(P_Out) = V(P_Out) + W(P_Out);

    uR.merge_ures(W);
    uR.set_bounds(k, 0, K)
      .set_bounds(iii, 0, III, ii, 0, II, i, 0, I);
    Out.set_bounds(iii, 0, III, ii, 0, II, i, 0, I);

    // Put all the UREs inside the same loop nest of X.
    uA.merge_ures(uX, uZ, V);

    // Explicitly set the loop bounds
    uA.set_bounds(iii, 0, III)
      .set_bounds(kk,  0, KK,     ii,  0, II)
      .set_bounds(k,   i, K - i,  i,   0, I);

    // Create a systolic array
    uA.space_time_transform(iii);

    // Put all the UREs inside the same loop nest of X.
    uA_T.merge_ures(uX_T, uZ_T, V_T);

    // Explicitly set the loop bounds
    uA_T.set_bounds(iii, 0, III)
        .set_bounds(kk,  0, KK,   ii,  0, II)
        .set_bounds(k,   0, K,    i,   k, I - k);

    // Create a systolic array
    uA_T.space_time_transform(iii);

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
    // TODO: share the same ALoader and insert a transposed buffer
    Func ALoader_T("ALoader_T", Place::Device), AFeeder_T("AFeeder_T", Place::Device);
    uA_T.isolate_producer_chain(A, ALoader_T, AFeeder_T);
    AFeeder_T.buffer(ALoader_T, i);
    AFeeder_T.scatter(ALoader_T, iii);

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

    // Compile the kernel to an FPGA bitstream, and expose a C interface for the host to invoke
    Target acc = get_host_target();
    acc.set_feature(Target::IntelFPGA);
    acc.set_feature(Target::EnableSynthesis);
    Out.compile_to_host("symv-interface", { A, X }, "symv", acc);
    printf("Success\n");
    return 0;
}
