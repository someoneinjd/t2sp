#include "util.h"

using namespace Halide;

int main(int argc, char **argv) {
    // Check constants are emitted correctly
    Func myout;
    complex64_t constant(100.0, 101.1);
    myout() = constant;
    myout.compile_to_bitcode("a.double.bitcode", {});
    myout.compile_to_llvm_assembly("a.double.as", {});

    Buffer<complex64_t> buf = myout.realize();
    if (buf(0) != constant) {
        printf("buf(0) = (%f, %fi) instead of (%f, %fi)\n", buf(0).re(), buf(0).im(), constant.re(), constant.im());
        abort();
    }

    printf("Success!\n");
    return 0;
}
