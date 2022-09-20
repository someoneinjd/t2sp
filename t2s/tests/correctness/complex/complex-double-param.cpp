#include "util.h"

using namespace Halide;

int main(int argc, char **argv) {
    // Check complex parameters
    Param<complex64_t> a;
    Param<complex64_t> b;
    a.set(complex64_t(1.5, -2.0));
    b.set(complex64_t(1.5, 2.0));
    complex64_t result = evaluate<complex64_t>(a + b);
    if (result != complex64_t(1.5, -2.0) + complex64_t(1.5, 2.0)) {
        printf("Incorrect result (%f, %fi)!\n", result.re(), result.im());
        abort();
    }
    result = evaluate<complex64_t>(a - b);
    if (result != complex64_t(1.5, -2.0) - complex64_t(1.5, 2.0)) {
        printf("Incorrect result (%f, %fi)!\n", result.re(), result.im());
        abort();
    }
    result = evaluate<complex64_t>(a * b);
    if (result != complex64_t(1.5, -2.0) * complex64_t(1.5, 2.0)) {
        printf("Incorrect result (%f, %fi)!\n", result.re(), result.im());
        abort();
    }
    result = evaluate<complex64_t>(a / b);
    if (result != complex64_t(1.5, -2.0) / complex64_t(1.5, 2.0)) {
        printf("Incorrect result (%f, %fi)!\n", result.re(), result.im());
        abort();
    }

    printf("Success!\n");
    return 0;
}
