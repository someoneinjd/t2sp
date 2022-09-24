// Our BLAS kernel's interface to users is MKL's CBLAS interface
#include "mkl_cblas.h"

// Our compiler generates a kernel and an internal interface for it.
//#include "gemm.h"

// Constant parameters of the kernel
#include "const-parameters.h"

// Headers for Halide/T2S types and data structures.
#include "Halide.h"
#include "HalideBuffer.h"

using namespace Halide;

template<typename CONST_TYPE, typename ELEM_TYPE, Type (*OP)(int), int Type_size>
void cblas_gemm(const CBLAS_LAYOUT Layout, const CBLAS_TRANSPOSE TransA,
                const CBLAS_TRANSPOSE TransB, const MKL_INT M, const MKL_INT N,
                const MKL_INT K, const CONST_TYPE alpha, const ELEM_TYPE *A,
                const MKL_INT lda, const ELEM_TYPE *B, const MKL_INT ldb,
                const CONST_TYPE beta, ELEM_TYPE *C, const MKL_INT ldc) {
    // Check parameters according to CBLAS interface conventions
    _halide_user_assert(M >= 0 && N >= 0 && K >= 0);

    _halide_user_assert(!(Layout == CblasColMajor && TransA == CblasNoTrans) || lda >= std::max(1, M));
    _halide_user_assert(!(Layout == CblasColMajor && TransA != CblasNoTrans) || lda >= std::max(1, K));
    _halide_user_assert(!(Layout == CblasRowMajor && TransA == CblasNoTrans) || lda >= std::max(1, K));
    _halide_user_assert(!(Layout == CblasRowMajor && TransA != CblasNoTrans) || lda >= std::max(1, M));

    _halide_user_assert(!(Layout == CblasColMajor && TransB == CblasNoTrans) || ldb >= std::max(1, K));
    _halide_user_assert(!(Layout == CblasColMajor && TransB != CblasNoTrans) || lda >= std::max(1, N));
    _halide_user_assert(!(Layout == CblasRowMajor && TransB == CblasNoTrans) || lda >= std::max(1, N));
    _halide_user_assert(!(Layout == CblasRowMajor && TransB != CblasNoTrans) || lda >= std::max(1, K));

    _halide_user_assert(!(Layout == CblasColMajor) || ldc >= std::max(1, M));
    _halide_user_assert(!(Layout == CblasRowMajor) || lda >= std::max(1, N));

    // Initialize input buffers
    auto bufferA = init_matrix_buffer(TransA == CblasNoTrans ? M : K, TransA == CblasNoTrans ? K : M, const_cast<ELEM_TYPE*>(A), lda);
    auto bufferB = init_matrix_buffer(TransB == CblasNoTrans ? K : N, TransB == CblasNoTrans ? N : K, const_cast<ELEM_TYPE*>(B), ldb);
    auto bufferC = init_matrix_buffer(M, N, C, ldc);

    // Allocate an output buffer.
    // TODO: reuse C as the output buffer
    int I = (M + III * II - 1) / (III * II);
    int J = (N + JJJ * JJ - 1) / (JJJ * JJ);
    Halide::Runtime::Buffer<ELEM_TYPE> bufferO(JJJ, III, JJ, II, J, I);
    if (typeid(OP) == typeid(type_of_float) && Type_size == 32) {
        t2s_generated_sgemm(TransA, TransB, alpha, beta, bufferA, bufferB, bufferC, bufferO);
    } else if (typeid(OP) == typeid(type_of_float) && Type_size == 64) {
        t2s_generated_dgemm(TransA, TransB, alpha, beta, bufferA, bufferB, bufferC, bufferO);
    } else if (typeid(OP) == typeid(type_of_complex) && Type_size == 32) {
        t2s_generated_cgemm(TransA, TransB, alpha, beta, bufferA, bufferB, bufferC, bufferO);
    } else {
        assert (typeid(OP) == typeid(type_of_complex) && Type_size == 64);
        t2s_generated_zgemm(TransA, TransB, alpha, beta, bufferA, bufferB, bufferC, bufferO);
    }

    // Copy the results from the output buffer into C
    for (int i = 0; i < I; i++)
    for (int j = 0; j < J; j++)
        for (int ii = 0; ii < II; ii++)
        for (int jj = 0; jj < JJ; jj++)
            for (int iii = 0; iii < III; iii++)
            for (int jjj = 0; jjj < JJJ; jjj++) {
                size_t total_i = iii + III * ii + III * II * i;
                size_t total_j = jjj + JJJ * jj + JJJ * JJ * j;
                auto value = = bufferO(jjj, iii, jj, ii, j, i);
                if (Layout == CblasColMajor)
                    C[total_i + total_j * ldc] = value;
                else
                    C[total_j + total_i * ldc] = value;
            }

    return;
}

// Define the CBLAS kernels in terms of our own gemm.
void cblas_sgemm(const CBLAS_LAYOUT Layout, const CBLAS_TRANSPOSE TransA,
                 const CBLAS_TRANSPOSE TransB, const MKL_INT M, const MKL_INT N,
                 const MKL_INT K, const float alpha, const float *A,
                 const MKL_INT lda, const float *B, const MKL_INT ldb,
                 const float beta, float *C, const MKL_INT ldc) {
    cblas_gemm<float, float, type_of_float, 32>(Layout, TransA, TransB, M, N, K, alpha, A, lda, B, ldb, beta, C, ldc);
}

void cblas_dgemm(const CBLAS_LAYOUT Layout, const CBLAS_TRANSPOSE TransA,
                 const CBLAS_TRANSPOSE TransB, const MKL_INT M, const MKL_INT N,
                 const MKL_INT K, const double alpha, const double *A,
                 const MKL_INT lda, const double *B, const MKL_INT ldb,
                 const double beta, double *C, const MKL_INT ldc) {
    cblas_gemm<double, double, type_of_float, 64>(Layout, TransA, TransB, M, N, K, alpha, A, lda, B, ldb, beta, C, ldc);
}

void cblas_cgemm(const CBLAS_LAYOUT Layout, const CBLAS_TRANSPOSE TransA,
                 const CBLAS_TRANSPOSE TransB, const MKL_INT M, const MKL_INT N,
                 const MKL_INT K, const void *alpha, const void *A,
                 const MKL_INT lda, const void *B, const MKL_INT ldb,
                 const void *beta, void *C, const MKL_INT ldc) {
    cblas_gemm<const void*, void, type_of_complex, 32>(Layout, TransA, TransB, M, N, K, alpha, A, lda, B, ldb, beta, C, ldc);
}

void cblas_zgemm(const CBLAS_LAYOUT Layout, const CBLAS_TRANSPOSE TransA,
                 const CBLAS_TRANSPOSE TransB, const MKL_INT M, const MKL_INT N,
                 const MKL_INT K, const void *alpha, const void *A,
                 const MKL_INT lda, const void *B, const MKL_INT ldb,
                 const void *beta, void *C, const MKL_INT ldc) {
    cblas_gemm<const void*, void, type_of_complex, 64>(Layout, TransA, TransB, M, N, K, alpha, A, lda, B, ldb, beta, C, ldc);
}
