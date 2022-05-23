#include "util.h"

using namespace Halide;

int main(int argc, char **argv) {
    // Write a constant value and check we can read it back. Mostly
    // this checks the addressing math is doing the right thing for
    // complex32_t.
    {
        Halide::Buffer<complex32_t> img(10, 3);
        img.set_min(4, -6);

        img.for_each_element([&](int x, int y) {
                img(x, y) = complex32_t(x + y / 8.0, y + x / 8.0);
            });

        if (img.size_in_bytes() != img.number_of_elements() * 8) {
            printf("Incorrect amount of memory allocated\n");
            abort();
        }

        for (int y = img.dim(1).min(); y <= img.dim(1).max(); y++) {
            for (int x = img.dim(0).min(); x <= img.dim(0).max(); x++) {
                complex32_t correct = complex32_t(x + y / 8.0, y + x / 8.0);
                complex32_t actual = img(x, y);
                if (correct != actual) {
                    printf("img(%d, %d) = (%f, %fi) instead of (%f, %fi)\n",
                        x, y, actual.re(), actual.im(), correct.re(), correct.im());
                    abort();
                }
            }
        }
    }

    // Check complex parameters
    {
        Param<complex32_t> a;
        Param<complex32_t> b;
        a.set(complex32_t(1.5f, -2.0f));
        b.set(complex32_t(1.5f, 2.0f));
        complex32_t result = evaluate<complex32_t>(a + b);
        if (result != complex32_t(1.5f, -2.0f) + complex32_t(1.5f, 2.0f)) {
            printf("Incorrect result (%f, %fi)!\n", result.re(), result.im());
            abort();
        }
        result = evaluate<complex32_t>(a - b);
        if (result != complex32_t(1.5f, -2.0f) - complex32_t(1.5f, 2.0f)) {
            printf("Incorrect result (%f, %fi)!\n", result.re(), result.im());
            abort();
        }
        result = evaluate<complex32_t>(a * b);
        if (result != complex32_t(1.5f, -2.0f) * complex32_t(1.5f, 2.0f)) {
            printf("Incorrect result (%f, %fi)!\n", result.re(), result.im());
            abort();
        }
        result = evaluate<complex32_t>(a / b);
        if (result != complex32_t(1.5f, -2.0f) / complex32_t(1.5f, 2.0f)) {
            printf("Incorrect result (%f, %fi)!\n", result.re(), result.im());
            abort();
        }
    }

    // Check constants are emitted correctly
    {
        Func out;
        complex32_t constant(100.0f, 101.1f);
        out() = constant;
        Buffer<complex32_t> buf = out.realize();
        if (buf(0) != constant) {
            printf("buf(0) = (%f, %fi) instead of (%f, %fi)\n", buf(0).re(), buf(0).im(), constant.re(), constant.im());
            abort();
        }
    }

    {
        Var x, y;
        ImageParam input(Complex(32), 2);
        Param<complex32_t> mul("mul");

        Func output("output", Complex(32), {x, y});
        output(x, y) = input(x, y) * mul;

        mul.set(complex32_t(2.0f, 2.0f));
        Buffer<complex32_t> in(8, 8);
        in.fill(complex32_t(0.25f, 0.25f));
        input.set(in);
        Buffer<complex32_t> buf = output.realize(8, 8);
        for (int y = 0; y < 8; y++) {
            for (int x = 0; x < 8; x++) {
                complex32_t correct = complex32_t(0.0f, 1.0f);
                if (buf(x, y) != correct) {
                    printf("buf(%d, %d) = (%f, %fi) instead of (%f, %fi)\n",
                           x, y, buf(x, y).re(), buf(x, y).im(), correct.re(), correct.im());
                    abort();
                }
            }
        }
    }

    // Check we can pass a complex32 to a FPGA kernel. 
    {
        Var x, y;
        ImageParam input(Complex(32), 2);
        Param<complex32_t> mul("mul");
        Func output("output", Complex(32), {x, y}, Place::Device);
        complex32_t constant(100.0f, 101.1f);

        output(x, y) = input(x, y) * mul + constant;

        mul.set(complex32_t(2.0f, 2.0f));
        Buffer<complex32_t> in(8, 8);
        in.fill(complex32_t(0.25f, 0.25f));
        input.set(in);

        Target target = get_host_target();
        target.set_feature(Target::IntelFPGA);
        target.set_feature(Target::Debug);
        // output.compile_jit(target);
        Buffer<complex32_t> buf = output.realize({8, 8}, target);
        for (int y = 0; y < 8; y++) {
            for (int x = 0; x < 8; x++) {
                complex32_t correct = complex32_t(100.0f, 102.1f);
                if (buf(x, y) != correct) {
                    printf("buf(%d, %d) = (%f, %fi) instead of (%f, %fi)\n",
                           x, y, buf(x, y).re(), buf(x, y).im(), correct.re(), correct.im());
                    abort();
                }
            }
        }
    }

    {
        Var x, y;
        Func output("output", Complex(32), {x, y}, Place::Device);
        complex32_t constant(100.0f, 0.0f);

        output(x, y) = fast_inverse_sqrt(constant) + sqrt(constant);

        Target target = get_host_target();
        target.set_feature(Target::IntelFPGA);
        target.set_feature(Target::Debug);
        // output.compile_jit(target);
        Buffer<complex32_t> buf = output.realize({8, 8}, target);
        for (int y = 0; y < 8; y++) {
            for (int x = 0; x < 8; x++) {
                complex32_t correct = complex32_t(10.1f, 0.0f);
                if (buf(x, y) != correct) {
                    printf("buf(%d, %d) = (%f, %fi) instead of (%f, %fi)\n",
                           x, y, buf(x, y).re(), buf(x, y).im(), correct.re(), correct.im());
                    abort();
                }
            }
        }
    }
    printf("Success!\n");
    return 0;
}
