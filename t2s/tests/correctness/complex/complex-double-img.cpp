#include "util.h"

using namespace Halide;

int main(int argc, char **argv) {
    // Check complex ImageParams
    Var x, y;
    ImageParam input(Complex(64), 2);
    Param<complex64_t> mul("mul");

    Func output("output", Complex(64), {x, y});
    output(x, y) = input(x, y) * mul;

    mul.set(complex64_t(2.0, 2.0));
    Buffer<complex64_t> in(8, 8);
    in.fill(complex64_t(0.25, 0.25));
    input.set(in);
    Buffer<complex64_t> buf = output.realize(8, 8);
    for (int y = 0; y < 8; y++) {
        for (int x = 0; x < 8; x++) {
            complex64_t correct = complex64_t(0.0, 1.0);
            if (buf(x, y) != correct) {
                printf("buf(%d, %d) = (%f, %fi) instead of (%f, %fi)\n",
                        x, y, buf(x, y).re(), buf(x, y).im(), correct.re(), correct.im());
                abort();
            }
        }
    }

    printf("Success!\n");
    return 0;
}
