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
// The header file generated by ger.cpp
#include "ger-interface.h"

// Constant parameters (inner loop bounds) of the design
#include "const-parameters.h"

// Outer loop bounds for testing
#ifdef TINY // For verifying correctness only
    #define K           2
    #define I           2
#else
    #define K           32
    #define I           32
#endif

// Roofline utilities
#include "Roofline.h"

// The only header file needed for including T2S.
#include "HalideBuffer.h"

// For printing output
#include <stdio.h>
#include <iostream>

// For validation of results.
#include <assert.h>

using namespace std;

int main()
{
    const int TOTAL_I = III * II * I;
    const int TOTAL_K = KKK * KK * K;

    Halide::Runtime::Buffer<float> a(TOTAL_K, TOTAL_I), x(TOTAL_I), y(TOTAL_K);
    for (size_t i = 0; i < TOTAL_I; i++) {
        for (size_t k = 0; k < TOTAL_K; k++) {
            a(k, i) = random();
        }
    }
    for (size_t i = 0; i < TOTAL_I; i++) {
        x(i) = random();
    }
    for (size_t k = 0; k < TOTAL_K; k++) {
        y(k) = random();
    }

    Halide::Runtime::Buffer<float> o(KKK, III, II, KK, K, I);
    ger(a, x, y, o);

#ifdef TINY
    // Validate the results
    for (int i = 0; i < I; i++)
    for (int k = 0; k < K; k++)
        for (int ii = 0; ii < II; ii++)
        for (int kk = 0; kk < KK; kk++)
            for (int iii = 0; iii < III; iii++)
            for (int kkk = 0; kkk < KKK; kkk++) {
                size_t total_i = iii + III * ii + III * II * i;
                size_t total_k = kkk + KKK * kk + KKK * KK * k;
                float golden = a(total_k, total_i) + x(total_i) * y(total_k);
                // cout << "(" << total_i << "," << total_k << ") " << x(total_i) << " * " << y(total_k) << " + " << a(total_k, total_i) << " = " << golden << " " << o(kkk, iii, ii, kk, k, i) << endl;
                assert(golden == o(kkk, iii, kk, ii, k, i) || fabs(golden - o(kkk, iii, ii, kk, k, i)) < 0.005*fabs(golden));
            }
#else
    // Report performance. DSPs, FMax and ExecTime are automatically figured out from the static analysis
    // during FPGA synthesis and and the dynamic profile during the FGPA execution.
#ifdef S10
    double mem_bandwidth = 75;
#else
    double mem_bandwidth = 33;
#endif
    double compute_roof = 2 * DSPs() * FMax();
    double number_ops = 2 * (double)(III * II * I) * (double)(KKK * KK * K); // Total operations (GFLOP for GER), independent of designs
    double number_bytes = (double)(III * II * I) * (double)(KKK * KK * K) * 4 +
                          (double)(III * II * I) * 4 + 
                          (double)(KKK * KK * K) * 4;
    double exec_time = ExecTime("kernel_unloader");
    roofline(mem_bandwidth, compute_roof, number_ops, number_bytes, exec_time);
    if (fopen("roofline.png", "r") == NULL) {
        cout << "Failed to draw roofline!\n";
        return 1;
    }
#endif

    printf("Success\n");
    return 0;
}
