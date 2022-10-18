// Use BLAS interface
#include "mkl_blas.h"

// For each of S/D/C/Z GEMM, our compiler generates a kernel and an internal interface for it.
#include "sgemm-interface.h"
#include "dgemm-interface.h"
#include "cgemm-interface.h"
#include "zgemm-interface.h"

// Some utilities.
#include "common.h"

#include <assert.h>

template<typename CONST_TYPE, typename ELEM_TYPE, Type (*OP)(int), int Type_size>
void GEMM(const char TransA, const char TransB, const MKL_INT M, const MKL_INT N, const MKL_INT K,
          const CONST_TYPE alpha, const ELEM_TYPE *a, const MKL_INT lda, const ELEM_TYPE *b, const MKL_INT ldb,
          const CONST_TYPE beta, ELEM_TYPE *c, const MKL_INT ldc) NOTHROW {
    // Check parameters according to BLAS interface conventions
    assert(M >= 0 && N >= 0 && K >= 0);
    assert(a && b && c);
    assert(transa != BlasNoTrans || LDA >= std::max(1, M));
    assert(transa == BlasNoTrans || LDA >= std::max(1, K));
    assert(transb != BlasNoTrans || LDB >= std::max(1, K));
    assert(transb == BlasNoTrans || LDB >= std::max(1, N));
    assert(LDC >= std::max(1, M));

    // Initialize input buffers
    auto bufferA = init_matrix_buffer(transa == BlasNoTrans ? M : K, transa == BlasNoTrans ? K : M, const_cast<ELEM_TYPE*>(a), LDA);
    auto bufferB = init_matrix_buffer(transb == BlasNoTrans ? K : N, transb == BlasNoTrans ? N : K, const_cast<ELEM_TYPE*>(b), LDB);
    auto bufferC = init_matrix_buffer(M, N, c, LDC);

    if (typeid(OP) == typeid(type_of_float) && Type_size == 32) {
        tblas_sgemm(TransA, TransB, alpha, beta, bufferA, bufferB, bufferC);
    } else if (typeid(OP) == typeid(type_of_float) && Type_size == 64) {
        tblas_dgemm(TransA, TransB, alpha, beta, bufferA, bufferB, bufferC);
    } else if (typeid(OP) == typeid(type_of_complex) && Type_size == 32) {
        tblas_cgemm(TransA, TransB, alpha, beta, bufferA, bufferB, bufferC);
    } else {
        assert (typeid(OP) == typeid(type_of_complex) && Type_size == 64);
        tblas_zgemm(TransA, TransB, alpha, beta, bufferA, bufferB, bufferC);
    }
}

// Define the BLAS kernels in terms of our own gemm. Arguments are in pointers as the interface is Fortran, which passes arguments in references.
void SGEMM(const char *transa, const char *transb, const MKL_INT *m, const MKL_INT *n, const MKL_INT *k,
           const float *alpha, const float *a, const MKL_INT *lda, const float *b, const MKL_INT *ldb,
           const float *beta, float *c, const MKL_INT *ldc) NOTHROW {
    GEMM<float, float, type_of_float, 32>(*transa, *transb, *m, *n, *k, *alpha, a, *lda, b, *ldb, *beta, c, *ldc);
}

void DGEMM(const char *transa, const char *transb, const MKL_INT *m, const MKL_INT *n, const MKL_INT *k,
           const double *alpha, const double *a, const MKL_INT *lda, const double *b, const MKL_INT *ldb,
           const double *beta, double *c, const MKL_INT *ldc) NOTHROW {
    GEMM<double, double, type_of_float, 64>(*transa, *transb, *m, *n, *k, *alpha, a, *lda, b, *ldb, *beta, c, *ldc);
}

void CGEMM(const char *transa, const char *transb, const MKL_INT *m, const MKL_INT *n, const MKL_INT *k,
           const MKL_Complex8 *alpha, const MKL_Complex8 *a, const MKL_INT *lda,
           const MKL_Complex8 *b, const MKL_INT *ldb, const MKL_Complex8 *beta,
           MKL_Complex8 *c, const MKL_INT *ldc) NOTHROW {
    GEMM<void*, void, type_of_complex, 32>(*transa, *transb, *m, *n, *k, *alpha, a, *lda, b, *ldb, *beta, c, *ldc);
}

void ZGEMM(const char *transa, const char *transb, const MKL_INT *m, const MKL_INT *n, const MKL_INT *k,
           const MKL_Complex16 *alpha, const MKL_Complex16 *a, const MKL_INT *lda,
           const MKL_Complex16 *b, const MKL_INT *ldb, const MKL_Complex16 *beta,
           MKL_Complex16 *c, const MKL_INT *ldc) NOTHROW {
    GEMM<void*, void, type_of_complex, 64>(*transa, *transb, *m, *n, *k, *alpha, a, *lda, b, *ldb, *beta, c, *ldc);
}
