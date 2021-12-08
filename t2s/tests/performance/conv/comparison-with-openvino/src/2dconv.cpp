#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <memory>
#include <string>
#include <time.h>
#include "cm_rt.h"
#include "common/cm_rt_helpers.h"
#include "common/isa_helpers.h"
#include "conv_cm_params.h"

//#define CHECK_RESULTS

int check_correctness(float *o_buf, float *w_buf, float *x_buf) {
    int cnt=0;
    for (size_t b = 0; b < B; b++)
        for (size_t co = 0; co < CO; co++)
            for (size_t h = 0; h < H; h++)
                for (size_t w = 0; w < W; w++)
                    for (size_t hh = 0; hh < HH; hh++)
                        for (size_t ww = 0; ww < WW; ww++)
                            for (size_t hhh = 0; hhh < HHH; hhh++)
                                for (size_t www = 0; www < WWW; www++) {
                                    float golden = 0.0f;
                                    int coi = co % COI;
                                    int coo = co / COI;
                                    for (size_t r_ci = 0; r_ci < CII * CIO; r_ci++)
                                        for (size_t r_kw = 0; r_kw < R_KW; r_kw++)
                                            for (size_t r_kh = 0; r_kh < R_KH; r_kh++) {
                                                int r_cii = r_ci % CII;
                                                int r_cio = r_ci / CII;
                                                int x_index_0 = (r_cii + CII * r_cio) + CII * CIO * b + CII * CIO * B * w + CII * CIO * B * W * h;
                                                int x_index_1 = (www + r_kw) + INPUT_WWW * (hhh + r_kh) + INPUT_WWW * INPUT_HHH * ww + INPUT_WWW * INPUT_HHH * WW * hh;
                                                int w_index_0 = coo * COI + coi;
                                                int w_index_1 = r_cii + CII * r_kw + CII * R_KW * r_kh + CII * R_KW * R_KH * r_cio;

                                                golden += x_buf[x_index_0 + (CII * CIO * B * W * H) * x_index_1] * w_buf[w_index_0 + CO * w_index_1];
                                    }
                                    int o_index_0 = (coi + COI * coo) + CO * b + CO * B * w + CO * B * W * h;
                                    int o_index_1 = www + WWW * hhh + WWW * HHH * ww + WWW * HHH * WW * hh;
                                    float iter = o_buf[o_index_0 + CO * B * W * H * o_index_1];
                                    if (fabs(iter - golden) > 1e-6) {
                                        printf("(%d, %d, %d, %d, %d, %d, %d, %d): %f != %f\n", b, co, h, w, hh, ww, hhh, www, iter, golden);
                                        cnt++;
                                        //return -1;
                                    }
                        }
    return cnt;
}

int main(int argc, char* argv[]) {
    //create CM device
    CmDevice* device = nullptr;
    unsigned version = 0;
    cm_result_check(::CreateCmDevice(device, version));

    //create conv_2d kernel
    std::string isa_code = cm::util::isa::loadFile(ISA_NAME);
    if (isa_code.empty()) {
        std::cerr << "Error: empty ISA binary.\n";
        std::exit(1);
    }

    CmProgram* program = nullptr;
    cm_result_check(device->LoadProgram(const_cast<char*>(isa_code.data()),
        isa_code.size(),
        program));

    CmKernel* kernel_2dconv_t2s = nullptr;
    cm_result_check(device->CreateKernel(program,
        "kernel_Z_WAIT_FINISH",
        kernel_2dconv_t2s));

    //create thread group space
    CmThreadGroupSpace* thread_group_space = nullptr;
    cm_result_check(device->CreateThreadGroupSpace(WW, HH, COO*W, B*H, thread_group_space));

    float* w, * x;
    //copy data to GPU, get surface index and set kernel argument
    CmSurface2D* out_surface = nullptr;
    cm_result_check(device->CreateSurface2D(WDITH_O, HEIGHT_O, CM_SURFACE_FORMAT_R32F, out_surface));
    SurfaceIndex* out_surface_idx = nullptr;
    cm_result_check(out_surface->GetIndex(out_surface_idx));
    cm_result_check(kernel_2dconv_t2s->SetKernelArg(0,
        sizeof(SurfaceIndex),
        out_surface_idx));

    srand(time(NULL));
    x = new float[XMAX];
    for (int i = 0; i < XMAX; ++i)
        x[i] = 1;

    CmSurface2D* input_surface_x = nullptr;
    cm_result_check(device->CreateSurface2D(WDITH_X, HEIGHT_X, CM_SURFACE_FORMAT_R32F, input_surface_x));
    cm_result_check(input_surface_x->WriteSurface((unsigned char*)(x), nullptr));
    SurfaceIndex* input_surface_x_idx = nullptr;
    cm_result_check(input_surface_x->GetIndex(input_surface_x_idx));
    cm_result_check(kernel_2dconv_t2s->SetKernelArg(1,
        sizeof(SurfaceIndex),
        input_surface_x_idx));

    w = new float[WMAX];
    for (int i = 0; i < WMAX; ++i)
        w[i] = 1;
    CmSurface2D* input_surface_w = nullptr;
    cm_result_check(device->CreateSurface2D(WDITH_Y, HEIGHT_Y, CM_SURFACE_FORMAT_R32F, input_surface_w));
    cm_result_check(input_surface_w->WriteSurface((unsigned char*)(w), nullptr));
    SurfaceIndex* input_surface_w_idx = nullptr;
    cm_result_check(input_surface_w->GetIndex(input_surface_w_idx));
    cm_result_check(kernel_2dconv_t2s->SetKernelArg(2,
        sizeof(SurfaceIndex),
        input_surface_w_idx));

    // Creates a task queue.
    CmQueue* cmd_queue = nullptr;
    cm_result_check(device->CreateQueue(cmd_queue));

    UINT64 min_time = SIZE_MAX;
    UINT64 avg_time = 0;
#ifdef CHECK_RESULTS
    float* buf = new float[QMAX];
#endif // CHECK_RESULTS
    for (size_t i = 0; i < ITER; i++) {
        // Creates a CmTask object.
        CmTask* task = nullptr;
        cm_result_check(device->CreateTask(task));

        // Adds a CmKernel pointer to CmTask.
        cm_result_check(task->AddKernel(kernel_2dconv_t2s));

        device->InitPrintBuffer();
        UINT64 executionTime = 0;
        CmEvent* sync_event = nullptr;

        cm_result_check(cmd_queue->EnqueueWithGroup(task,
            sync_event,
            thread_group_space));
        cm_result_check(sync_event->WaitForTaskFinished(2000));
        cm_result_check(sync_event->GetExecutionTime(executionTime));
        
        if (executionTime < min_time)
            min_time = executionTime;
        avg_time += executionTime;
        printf("Exec time:%ld\n", executionTime);

#ifdef CHECK_RESULTS
        // Reads the output surface content to the system memory using the CPU.
        cm_result_check(out_surface->ReadSurface((unsigned char*)buf, sync_event));
        device->FlushPrintBuffer();
#endif
        // Destroys a CmTask object.
        cm_result_check(cmd_queue->DestroyEvent(sync_event));
        cm_result_check(device->DestroyTask(task));
    }

#ifdef CHECK_RESULTS
    int cnt = check_correctness(buf, w, x);
    if (cnt != 0)
        printf("Error:%d/%d\n",cnt,SIZE_O);
    else
        printf("Success!\n");
    delete[] buf;
#endif // CHECK_RESULTS

    std::cout << "Peak GFlops: " << FLOPS/(double)min_time << "\n";
    std::cout << "Avg GFlops: " <<  FLOPS/((double)avg_time/ITER) << "\n";

    // Destroy a CmThreadSpace object.
    if (thread_group_space) {
        device->DestroyThreadGroupSpace(thread_group_space);
    }
    cm_result_check(::DestroyCmDevice(device));

    delete[] x;
    delete[] w;

    return 0;
}
