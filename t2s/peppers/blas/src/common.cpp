#include <string.h>
#include <iostream>
#include <ctype.h>
#include "./common.h"

// Below is adapted from Halide/apps/linear_algebra/src/halide_blas.cpp
using Halide::Runtime::Buffer;

namespace {

template<typename T>
Buffer<T> init_scalar_buffer(T *x) {
    return Buffer<T>(x, {});
}

template<typename T>
Buffer<T> init_vector_buffer(const int N, T *x, const int incx) {
    halide_dimension_t shape = {0, N, incx};
    return Buffer<T>(x, 1, &shape);
}

template<typename T>
Buffer<T> init_matrix_buffer(const int M, const int N, T *A, const int lda) {
    halide_dimension_t shape[] = {{0, M, 1}, {0, N, lda}};
    return Buffer<T>(A, 2, shape);
}

}
