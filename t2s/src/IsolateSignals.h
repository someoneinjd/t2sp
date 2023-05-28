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
#ifndef T2S_ISOLATE_SIGNALS_H
#define T2S_ISOLATE_SIGNALS_H

/** \file
 *
 * Defines a pass to isolate signals out of run_forever kernels.
 *
 */

#include "../../Halide/src/IR.h"

using std::vector;
using std::map;
using std::string;
using std::pair;

namespace Halide {
namespace Internal {

/* Isolate signals out of the kernels marked as run_forever */
extern Stmt isolate_signals(const Stmt &s, map<string, Function> &env);

}
}

#endif
