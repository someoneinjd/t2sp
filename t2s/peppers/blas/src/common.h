#ifndef BLAS_COMMON_H
#define BLAS_COMMON_H

// Below is adapted from Halide/apps/linear_algebra/src/halide_blas.cpp
#include "Halide.h"
#include "HalideBuffer.h"
using Halide::Runtime::Buffer;

namespace {

template<typename T>
Buffer<T> init_scalar_buffer(T *x);

template<typename T>
Buffer<T> init_vector_buffer(const int N, T *x, const int incx);

template<typename T>
Buffer<T> init_matrix_buffer(const int M, const int N, T *A, const int lda);

}

#endif
