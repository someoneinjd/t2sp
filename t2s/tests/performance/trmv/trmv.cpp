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
    #define P               kkk,       iii,   ii, kk,      k,   i
    #define P_iii_minus_1   kkk,       iii-1, ii, kk,      k,   i
    #define P_kkk_minus_1   kkk-1,     iii,   ii, kk,      k,   i
    #define P_kk_minus_1    kkk+KKK-1, iii,   ii, kk-1,    k,   i
    #define P_k_minus_1     kkk+KKK-1, iii,   ii, kk+KK-1, k-1, i
    #define P_Out                      iii,   ii,               i

    // Linearized addresses
    #define total_i         (iii + III * ii + III * II * i)
    #define total_k         (kkk + KKK * kk + KKK * KK * k)

    // Outer loop bounds, which are determined by input sizes
    #define I (A.dim(1).extent() / (III * II))
    #define K (A.dim(0).extent() / (KKK * KK))

    // Type of the data to process in C and T2S
    #define CTYPE float
    #define TTYPE Float(32)

    // Inputs
    ImageParam A("A", TTYPE, 2), X("X", TTYPE, 1);

    // UREs
    Var kkk("kkk"), iii("iii"), kk("kk"), ii("ii"), k("k"), i("i");
    URE uA("uA", TTYPE, {P}), uX("uX", TTYPE, {P}), uZ("uZ", TTYPE, {P}), V("V");
    uA(P) = A(total_k, total_i);
    uX(P) = select(iii == 0, X(total_k), uX(P_iii_minus_1));
    uZ(P) = select(kkk == 0 && kk == 0 && k == i, 0,
                   select(kkk == 0, 
                          select(kk == 0, uZ(P_k_minus_1), uZ(P_kk_minus_1)),
                          uZ(P_kkk_minus_1)))
                   + uA(P) * uX(P);

    V(P_Out) = select(kkk == KKK-1 && kk == KK-1 && k == K-1, uZ(P));

    // Put all the UREs inside the same loop nest of X.
    uA.merge_ures(uX, uZ, V);

    // Explicitly set the loop bounds
    uA.set_bounds(kkk, 0, KKK,    iii, 0, III)
      .set_bounds(kk,  0, KK,     ii,  0, II)
      .set_bounds(k,   i, K - i,  i,   0, I);

    // Create a systolic array
    uA.space_time_transform(iii);

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

    Func deserializer("deserializer", Place::Host), unloader("unloader", Place::Device);
    V.isolate_consumer_chain(unloader, deserializer);

    // Note: ALoader cannot be vectorized, because different SIMD lanes are loading
    // AValues, which are conditioned with different kkk. The compiler requires that
    // all SIMD lanes have the same condition.
    ALoader.vectorize(kkk);
    XLoader.vectorize(kkk);
    XFeeder.vectorize(kkk);
    uA.vectorize(kkk);

    // Compile the kernel to an FPGA bitstream, and expose a C interface for the host to invoke
    Target acc = get_host_target();
    acc.set_feature(Target::IntelFPGA);
    acc.set_feature(Target::EnableSynthesis);
    deserializer.compile_to_host("trmv-interface", { A, X }, "trmv", acc);
    printf("Success\n");
    return 0;
}
