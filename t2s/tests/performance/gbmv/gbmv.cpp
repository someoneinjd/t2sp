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
    // Dependences for a single thread
    #define P                         vi,       iii,    kkk,    ii,  kk,  i,  k
    #define P_vi_minus_1              vi-1,     iii,    kkk,    ii,  kk,  i,  k
    #define P_kkk_minus_1_vi_plus_1   vi+1,     iii,    kkk-1,  ii,  kk,  i,  k
    #define P_kkk_minus_1_iii_plus_1  vi-VI+1,  iii+1,  kkk-1,  ii,  kk,  i,  k
    #define P_top                                       kkk,    ii,  kk,  i,  k
    #define P_right                   vi,       iii,            ii,  kk,  i,  k

    // Linearized addresses
    #define total_i           (vi + VI*iii + VI*III*ii + VI*III*II*i)
    #define total_k           (kkk + KKK*kk + KKK*KK*k)

    // Outer loop bounds, which are determined by input sizes
    #define I               (A.dim(1).extent() / (VI * III * II))
    #define K               (A.dim(0).extent() / (KKK * KK))

    // Type of the data to process in C and T2S
    #define CTYPE float
    #define TTYPE Float(32)

    // Inputs
    ImageParam A("A", TTYPE, 2), X("X", TTYPE, 1);

    // UREs for MV
    Var vi("vi"), iii("iii"), kkk("kkk"), kk("kk"), ii("ii"), k("k"), i("i");
    URE fX("fX", TTYPE, {P}), MV("MV", TTYPE, {P});
    URE TopOut("TopOut"), RightOut("RightOut");
    fX(P) = select(vi == 0, X(total_k), fX(P_vi_minus_1));
    MV(P) = select(kkk == 0 || (vi == VI-1 && iii == III-1), 0,
                    select(vi == VI-1, MV(P_kkk_minus_1_iii_plus_1),
                                       MV(P_kkk_minus_1_vi_plus_1))
                  ) + A(total_k, total_i) * fX(P);
    TopOut(P_top) = select(vi == 0 && iii == 0, MV(P));
    RightOut(P_right) = select(kkk == KKK-1, select(vi == 0 && iii == 0, 0, MV(P)));

    fX.merge_ures(MV, TopOut, RightOut);
    fX.set_bounds(iii, 0, III, kkk, 0, KKK)
      .set_bounds(ii,  0, II,  kk,  0, KK)
      .set_bounds(i,   0, I,   k,   0, K)
      .set_bounds(vi,  0, VI);
    fX.space_time_transform(vi);
    // fX.blocks(i, k).threads(ii, kk);

    Var lin_k("lin_k"), lin_i("lin_i"), blk_i("blk_i"), all_i("all_i");
    Func Scol("Scol", Place::Device), Srow("Srow", Place::Device);
    Scol(lin_i, kk, i, k) = RightOut(lin_i % VI, (lin_i/VI) % III, lin_k/(VI*III), kk, i, k);
    Srow(lin_k, ii, i, k) = TopOut(lin_k % KKK, ii, lin_k / KKK, i, k);
    Scol.set_bounds(lin_i, 0, VI*III*II, i, 0, I)
        .set_bounds(kk, 0, KK, k, 0, K);
    Srow.set_bounds(lin_k, 0, KKK*K, k, 0, K)
        .set_bounds(ii, 0, II, i, 0, I);

    Func blkReduce("blkReduce", Place::Device);
    RDom blkRow(0, KKK*KK, 0, II), blkCol(0, VI*III*II, 0, KK);
    blkReduce(blk_i, i, k) = 0.0f;
    blkReduce(blkCol.x + blkCol.y*KKK, i, k) += Scol(blkCol.x, blkCol.y, i, k);
    blkReduce(blkRow.x + blkRow.y*III*VI, i, k) += Srow(blkRow.x, blkRow.y, i, k);
    blkReduce.set_bounds(blk_i, 0, VI*III*II+KKK*KK-1)
             .set_bounds(i, 0, I, k, 0, K);
    // blkReduce.blocks(i, k);

    // I/O network
    // Stensor DA(DRAM), DX(DRAM), SA(SRAM), SX(SRAM);
    // Stensor ST(SRAM), SR(SRAM), DP(DRAM), psum, Y;
    // A >> DA.out(vi) >> SA.scope(i).out(vi) >> fX;
    // X >> DX.out(vi) >> SX.scope(i).out(vi) >> fX;
    // TopOut >> Srow(kkk+KKK*kk, ii).scope(i) >> blkReduce;
    // RightOut >> Scol(vi+VI*iii+VI*III*ii, kk).scope(i) >> blkReduce;
    // blkReduce >> Dpsum >> allReduce >> Y(all_i-Ku);
    Func A_serializer("A_serializer", Place::Host), DA("DA", Place::Device);
    fX.isolate_producer_chain(A, A_serializer, DA);

    Func X_serializer("X_serializer", Place::Host), DX("DX", Place::Device), SX("SX", Place::Device);
    fX.isolate_producer_chain(X, X_serializer, DX, SX);
    DX.remove(vi, iii, ii);
    X_serializer.remove(vi, iii, ii, i);
    SX.buffer(DX, i);

    Func Dpsum("Dpsum", Place::Device);
    blkReduce.isolate_consumer_chain(Dpsum);

    Func allReduce("allReduce", Place::Host);
    RDom blkDim(0, VI*III*II+KKK*KK-1, 0, I, 0, K);
    allReduce(all_i) = 0.0f;
    allReduce(blkDim.x + VI*III*II*blkDim.y + KKK*KK*blkDim.z) += Dpsum(blkDim.x, blkDim.y, blkDim.z);
    allReduce.set_bounds(all_i, 0, VI*III*II*I+KKK*KK*K-1);

    // Compile the kernel to an FPGA bitstream, and expose a C interface for the host to invoke
    Target acc = get_host_target();
    acc.set_feature(Target::IntelFPGA);
    acc.set_feature(Target::EnableSynthesis);
    allReduce.compile_to_host("gbmv-interface", { A, X }, "gbmv", acc);
    printf("Success\n");

    return 0;
}
