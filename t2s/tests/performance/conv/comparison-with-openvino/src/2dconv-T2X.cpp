// A positive test for code gen, with input.
// On linux, you can compile and run it like so:
// g++ t2s/tests/correctness/GPU/1dconv-1.cpp -g -std=c++11  -I ./Halide/include -L ./Halide/bin -lHalide -lpthread -ldl
// LD_LIBRARY_PATH=Halide/bin ./a.out
// You can change SIZE to be arbitrary unsigned integer, remove -DVERBOSE_DEBUG for cleaner output without details, and set PLACE0 either as Place::Host or Place::Device.

#include "Halide.h"
#include "util.h"

using namespace Halide;

#include "conv_cm_params.h"

int main(void) {
#define P           coi, r_cii,       r_kw,        r_kh,        www,  hhh,      r_cio,   ww,  hh,   w_coo, h_b
#define P_cii__1    coi, r_cii-1,     r_kw,        r_kh,        www,  hhh,      r_cio,   ww,  hh,   w_coo, h_b
#define P_kw__1     coi, r_cii+CII-1, r_kw-1,      r_kh,        www,  hhh,      r_cio,   ww,  hh,   w_coo, h_b
#define P_kh__1     coi, r_cii+CII-1, r_kw+R_KW-1, r_kh-1,      www,  hhh,      r_cio,   ww,  hh,   w_coo, h_b
#define P_cio__1    coi, r_cii+CII-1, r_kw+R_KW-1, r_kh+R_KH-1, www,  hhh,      r_cio-1, ww,  hh,   w_coo, h_b
#define OUT         coi,                                        www,  hhh,      ww,  hh,            w_coo, h_b
#define LAYOUT_O    COI,                                        WWW,  HHH,      WW,  HH,            W*COO, H*B

#define REARGS_out  (coi+COI*coo) + CO*b + CO*B*w+CO*B*W*h, www + WWW*hhh + WWW*HHH*ww + WWW*HHH*WW*hh
#define P_X         (r_cii+CII*r_cio) + CII*CIO*b + CII*CIO*B*w + CII*CIO*B*W*h,  (www+r_kw) + INPUT_WWW*(hhh+r_kh) + INPUT_WWW*INPUT_HHH*ww + INPUT_WWW*INPUT_HHH*WW*hh
#define P_Y         coo*COI+coi, r_cii + CII*r_kw + CII*R_KW*r_kh + CII*R_KW*R_KH*r_cio

    ImageParam x(Float(32), 2), y(Float(32), 2);
    x.set(new_data_2D<float, LAYOUT_X>(VALUES::SEQUENTIAL));
    y.set(new_data_2D<float, LAYOUT_Y>(VALUES::SEQUENTIAL));

    Var P;
    Expr w = w_coo % W, coo = w_coo / W, h = h_b % H, b = h_b / H;
    Func out, Z(Float(32), {P});
    Z(P) =  select(r_cii != 0, Z(P_cii__1),
              select(r_kw != 0, Z(P_kw__1),
                select(r_kh != 0, Z(P_kh__1),
                  select(r_cio != 0, Z(P_cio__1), 0)))
            ) + x(P_X) * y(P_Y);
    out(OUT) = select(r_kw==R_KW-1 && r_kh==R_KH-1
                    && r_cii==CII-1 && r_cio==CIO-1, Z(P));

    // x.mem_fetch(hh, MemoryType::Register, {0, 0, 0, -1, 0, 1, 0, 0, 0, 0, 0});
    x.mem_fetch(hhh, MemoryType::Register);
    y.mem_fetch(r_cio, MemoryType::Register);
    out.mem_store({ REARGS_out });

    // Compile and run
    Z.merge_ures(out)
     .gpu_blocks(w_coo, h_b)
     .gpu_threads(ww, hh)
     .set_bounds(r_kw, 0, R_KW, r_kh, 0, R_KH)
     .set_bounds(coi, 0, COI)
     .set_bounds(www, 0, WWW, hhh, 0, HHH)
     .set_bounds(ww, 0, WW, hh, 0, HH)
     .set_bounds(w_coo, 0, W*COO, h_b, 0, H*B)
     //.set_bounds(w, 0, W, h, 0, H)
     .set_bounds(r_cii, 0, CII, r_cio, 0, CIO)
     //.set_bounds(b, 0, B, coo, 0, COO)
     .space_time_transform(coi, www, hhh);

    out.output_buffer().set_bounds(LAYOUT_O);
    x.set_bounds(LAYOUT_X);
    y.set_bounds(LAYOUT_Y);

    Target gpu = get_host_target();
    gpu.set_feature(Target::IntelGPU);
    out.compile_to_cm(KERNEL_NAME, {y, x}, gpu);

    return 0;
}
