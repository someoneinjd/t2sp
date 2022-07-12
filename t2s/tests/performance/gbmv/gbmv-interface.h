#ifndef HALIDE__gbmv___interface_h
#define HALIDE__gbmv___interface_h
#include "AOT-OpenCL-Runtime.h"



#ifdef __cplusplus
extern "C" {
#endif

HALIDE_FUNCTION_ATTRS
int gbmv(float _Alpha, float _Beta, struct halide_buffer_t *_A_buffer, struct halide_buffer_t *_X_buffer, struct halide_buffer_t *_Y_buffer, struct halide_buffer_t *_deserializer_buffer);

HALIDE_FUNCTION_ATTRS
int gbmv_argv(void **args);

HALIDE_FUNCTION_ATTRS
const struct halide_filter_metadata_t *gbmv_metadata();

#ifdef __cplusplus
}  // extern "C"
#endif

#endif
