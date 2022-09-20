#include "util.h"

using namespace Halide;

int main(int argc, char **argv) {
    // Check if the external call works for complex64_t on FPGA. 
    Var x, y;
    Func output("output", Complex(64), {x, y}, Place::Device);
    complex64_t constant(100.0, 0.0);

    output(x, y) = fast_inverse_sqrt(constant) + sqrt(constant);

    Target target = get_host_target();
    target.set_feature(Target::IntelFPGA);
    target.set_feature(Target::Debug);
    // output.compile_jit(target);
    Buffer<complex64_t> buf = output.realize({8, 8}, target);
    for (int y = 0; y < 8; y++) {
        for (int x = 0; x < 8; x++) {
            complex64_t correct = complex64_t(10.1, 0.0);
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
