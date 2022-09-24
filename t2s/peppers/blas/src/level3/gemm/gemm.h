#ifndef HALIDE__zgemm___interface_h
#define HALIDE__zgemm___interface_h
#include "AOT-OpenCL-Runtime.h"



#ifdef __cplusplus
extern "C" {
#endif

HALIDE_FUNCTION_ATTRS
int gemm(struct halide_buffer_t *_A_buffer, struct halide_buffer_t *_B_buffer, struct halide_buffer_t *_C_buffer);

HALIDE_FUNCTION_ATTRS
int gemm_argv(void **args);

HALIDE_FUNCTION_ATTRS
const struct halide_filter_metadata_t *gemm_metadata();

#ifdef __cplusplus
}  // extern "C"
#endif

#endif
