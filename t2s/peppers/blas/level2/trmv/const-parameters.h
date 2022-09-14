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
#ifndef GEMM_CONST_PARAMS_H
#define GEMM_CONST_PARAMS_H

// Inner loop bounds, which are static constant parameters of the design
#ifdef GPU
    #define III         32
    #define II          2
    #define JJJ         32
    #define JJ          2
#else // FPGA
    #ifdef TINY // For verifying correctness only
        #define III         4
        #define II          4
        #define JJJ         4
        #define JJ          4
    #else
        #define III         16
        #define II          32
        #define JJJ         16
        #define JJ          32
    #endif
#endif

#endif
