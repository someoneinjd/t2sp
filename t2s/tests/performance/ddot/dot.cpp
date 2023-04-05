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

#define KKK 8
#define KK  64

using namespace Halide;

int main()
{
    // Dependences
    #define P_1             kkk,             kk,      k,     b
    #define P_1_k_minus_1   kkk + KKK - 1,   kk,      k - 1, b
    #define P_1_kkk_minus_1 kkk - 1,         kk,      k,     b
    #define P_2                              kk,             b
    #define P_2_kk_minus_1                   kk - 1,         b
    #define P_out                                            b
    // Linearized addresses
    #define total_k         (kkk + KKK * kk + KKK * KK * k)

    // Outer loop bounds, which are determined by input sizes
    #define K (X.dim(0).extent() / (KK * KKK))
    #define B (X.dim(1).extent())

    // Type of the data to process in C and T2S
    #define CTYPE double
    #define TTYPE Float(64)

    // Inputs
    ImageParam X("X", TTYPE, 2);
    ImageParam Y("Y", TTYPE, 2);

    // UREs
    Var kkk("kkk"), kk("kk"), k("k"), b("b");
    URE uY("uY", TTYPE, {P_1}), uX("uX", TTYPE, {P_1}), uZ_1("uZ_1", TTYPE, {P_1}), Z("Z");
    URE uZ_2("uZ_2", TTYPE, {P_2}), Out("Out");
    uX(P_1) = X(total_k, b);
    uY(P_1) = Y(total_k, b);
    uZ_1(P_1) = select(k == 0 && kkk == 0, 0, select(kkk == 0, uZ_1(P_1_k_minus_1), uZ_1(P_1_kkk_minus_1))) + uX(P_1) * uY(P_1);
    Z(P_2) = select(k == K - 1 && kkk == KKK - 1, uZ_1(P_1));

    uZ_2(P_2) = select(kk == 0, 0, uZ_2(P_2_kk_minus_1)) + Z(P_2);
    Out(P_out) = select(kk == KK - 1, uZ_2(P_2));

    // Put all the UREs inside the same loop nest of X.
    uX.merge_ures(uY, uZ_1, Z);
    uZ_2.merge_ures(Out);
    uX.late_fuse(uZ_2, b);

    // Explicitly set the loop bounds
    uX.set_bounds(kkk,  0, KKK, kk,  0, KK,  k,  0, K)
      .set_bounds(b,    0, B);
    uZ_2.set_bounds(kk,  0, KK)
        .set_bounds(b,   0, B);
    uX.space_time_transform(kkk);
    uX.vectorize(kkk);
    uZ_2.unroll(kk);

    // I/O network
    Func xLoader(Place::Device), yLoader(Place::Device);
    Func xSerializer(Place::Host), ySerializer(Place::Host);
    uX.isolate_producer_chain(X, xSerializer, xLoader);
    uX.isolate_producer_chain(Y, ySerializer, yLoader);

    Func unloader(Place::Device), deserializer(Place::Host);
    Out.isolate_consumer_chain(unloader, deserializer);

    // Compile the kernel to an FPGA bitstream, and expose a C interface for the host to invoke
    Target target = get_host_target();
    target.set_feature(Target::Debug);
    target.set_feature(Target::IntelFPGA);

    deserializer.compile_to_host("dot-interface", { X, Y  }, "dot", target);
    printf("Success\n");
    return 0;
}
