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
#include "dot-interface.h"
// Outer loop bounds for testing
#ifdef TINY // For verifying correctness only
    #define K           16
#else
    #define KK          16
    #define K           4194304 
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
    const int TOTAL_K = KK * K;
    const int TOTAL_B = 1;

    Halide::Runtime::Buffer<double> x(TOTAL_K, TOTAL_B), y(TOTAL_K, TOTAL_B);

    for (size_t j = 0; j < TOTAL_K; j++) {
        for (size_t i = 0; i < TOTAL_B; i++) {
        x(j, i) = random();
        y(j, i) = random();    
    }}

    Halide::Runtime::Buffer<double> o(TOTAL_B);
    dot(x, y, o);

#ifdef TINY
    // Validate the results
    // for (int i = 0; i < I; i++)
    //     for (int ii = 0; ii < II; ii++)
    //         for (int iii = 0; iii < III; iii++) {
    //             size_t total_i = iii + III * ii + III * II * i;
    //             double golden = beta * yy(total_i);

    //             for (int j = 0; j < TOTAL_K; j++) {
    //                 double aa = opa == 0 ? a(j, total_i) : a(total_i, j);
    //                 double xx = x(j);
    //                 golden += alpha * aa * xx;
    //             }

    //             cout << golden << " " << y(iii, ii, i) << endl;
    //             assert(fabs(golden - y(iii, ii, i)) < 0.005*fabs(golden));
    //         }
    for (int i = 0; i < I; i++)
        for (int ii = 0; ii < II; ii++)
            for (int iii = 0; iii < III; iii++) {
                size_t total_i = iii + III * ii + III * II * i;
                double golden = 0;
                for (int j = 0; j < TOTAL_K; j++) {
                    double aa = a(j, total_i);
                    double xx = x(j);
                    golden += aa * xx;
                }
                assert(fabs(golden - y(iii, ii, i)) < 0.005*fabs(golden));
            }
#else
    // Report performance. DSPs, FMax and ExecTime are automatically figured out from the static analysis
    // during FPGA synthesis and and the dynamic profile during the FGPA execution.
    double mem_bandwidth = 33; // pac_a10 on DevCloud has 34GB/s memory bandwidth
    double compute_roof = 2 * DSPs() * FMax();
    double number_ops = 2.0 * TOTAL_K * TOTAL_B; // Total operations (GFLOP for GEMV), independent of designs
    double number_bytes =  2.0 * TOTAL_K * TOTAL_B * 8;
    double exec_time= ExecTime();
    roofline(mem_bandwidth, compute_roof, number_ops, number_bytes,exec_time);
    if (fopen("roofline.png", "r") == NULL) {
        cout << "Failed to draw roofline!\n";
        return 1;
    }
#endif

    printf("Success\n");
    return 0;
}
