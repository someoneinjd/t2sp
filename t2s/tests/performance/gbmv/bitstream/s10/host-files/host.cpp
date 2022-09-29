// Copyright (C) 2013-2019 Altera Corporation, San Jose, California, USA. All rights reserved.
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
// whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// This agreement shall be governed in all respects by the laws of the State of California and
// by the laws of the United States of America.


// This file is modified from /glob/development-tools/versions/fpgasupportstack/a10/1.2.1/intelFPGA_pro/hld/examples_aoc/matrix_mult/host/src/main.cpp

// Currently on DevCloud A10 nodes, Halide OpenCL runtime has issue in clFlush. So we temporarily provide this host file.
// We will no longer need it in future.
//
// compile and run (for example):
//      g++ host.cpp -DLARGE -g -DLINUX -DALTERA_CL -fPIC -Icommon/inc ./common/src/AOCLUtils/opencl.cpp ./common/src/AOCLUtils/options.cpp -I$ALTERAOCLSDKROOT/host/include $AOCL_LIBS -lelf -o host.out
//      Emulation:
//          env CL_CONTEXT_EMULATOR_DEVICE_INTELFPGA=1 BITSTREAM="a.aocx" ./host.out
//      HW: 
//          env BITSTREAM="conv_unsigned.aocx" ./host.out
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cstring>
#include <iostream>
#include "CL/opencl.h"
#include "CL/cl_ext_intelfpga.h"
#include "AOCLUtils/aocl_utils.h"

#include "const-parameters.h"
#define I           64
#define Ku          1023
#define Kl          1023

#define max(a, b)   ((a > b) ? a : b)
#define min(a, b)   ((a < b) ? a : b)

using namespace aocl_utils;

#define TYPE float

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#define DPRINTF(...)     \
    printf(__VA_ARGS__); \
    fflush(stdout);

#define NUM_QUEUES_TO_CREATE    7
#define NUM_KERNELS_TO_CREATE   7

#define CHECK(status)                                       \
    if (status != CL_SUCCESS) {                             \
        printf("error %d in line %d.\n", status, __LINE__); \
        exit(1);                                            \
    }

#define ACL_ALIGNMENT 64
void *acl_aligned_malloc(size_t size) {
    void *result = NULL;
    posix_memalign(&result, ACL_ALIGNMENT, size);
    return result;
}

const char *kernel_name[] = {
    "kernel_aLoader",
    "kernel_xLoader",
    "kernel_xFeeder",
    "kernel_V",
    "kernel_yLoader",
    "kernel_Out",
    "kernel_unloader"
};

double compute_kernel_execution_time(cl_event &event, double &start_d, double &end_d) {
    cl_ulong start, end;

    clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &end, NULL);
    clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &start, NULL);

    start_d = (double)1.0e-9 * start;
    end_d = (double)1.0e-9 * end;
    //return (double)(end-start);
    return (double)1.0e-9 * (end - start); // nanoseconds to seconds
}

int main(int argc, char **argv) {
    float *A, *X, *Y;
    const long TOTAL_I = III * II * I;
    const long TOTAL_J = TOTAL_I / 4;

    float alpha = 1;//random();
    float beta = 1;//random();

    if ((A = (float *)acl_aligned_malloc(TOTAL_I*TOTAL_J * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix A");
    }
    memset(A, 0, TOTAL_I*TOTAL_J * sizeof(float));
    if ((X = (float *)acl_aligned_malloc((TOTAL_J + TOTAL_I) * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix A");
    }
    memset(X, 0, (TOTAL_J + TOTAL_I) * sizeof(float));
    if ((Y = (float *)acl_aligned_malloc(TOTAL_I * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix A");
    }
    memset(Y, 0, TOTAL_I * sizeof(float));

    for (size_t i = 0; i < TOTAL_I; i++) {
        for (size_t j = 0; j < TOTAL_J; j++) {
            if (((j - i) > Ku) || ((i - j) > Kl)) continue;
            A[j + i*TOTAL_J] = i * TOTAL_J + j;//random();
        }
    }

    for (int j = 0; j < TOTAL_J; j++) {
        X[j + Ku] = j;//random();
    }

    for (int i = 0; i < TOTAL_I; i++) {
        Y[i] = i;//random();
    }

    int TOTAL_K = ((Ku + 1 + Kl + (KKK * KK - 1)) / (KKK * KK)) * (KKK * KK);
    int K = TOTAL_K / (KKK * KK);
    float *banded_A;
    if ((banded_A = (float *)acl_aligned_malloc(TOTAL_I*TOTAL_K * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix A");
    }
    memset(banded_A, 0, TOTAL_I*TOTAL_K * sizeof(float));
    for (int i = 0; i < TOTAL_I; i++) {
        int k = Kl - i;
        for (int j = max(0, i-Kl); j < min(TOTAL_J, i+Ku+1); j++) {
            banded_A[(k+j) + TOTAL_K*i] = A[j + i*TOTAL_J];
        }
    }

    float *serialized_A_1, *serialized_A_2, *serialized_A_3, *serialized_A_4;
    float *serialized_X, *serialized_Y;
    if ((serialized_A_1 = (float *)acl_aligned_malloc(TOTAL_I*TOTAL_K/4 * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix serialized_A");
    }
    if ((serialized_A_2 = (float *)acl_aligned_malloc(TOTAL_I*TOTAL_K/4 * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix serialized_A");
    }
    if ((serialized_A_3 = (float *)acl_aligned_malloc(TOTAL_I*TOTAL_K/4 * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix serialized_A");
    }
    if ((serialized_A_4 = (float *)acl_aligned_malloc(TOTAL_I*TOTAL_K/4 * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix serialized_A");
    }
    if ((serialized_X = (float *)acl_aligned_malloc(TOTAL_I*TOTAL_K * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix serialized_A");
    }
    if ((serialized_Y = (float *)acl_aligned_malloc(TOTAL_I * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix serialized_A");
    }

    // Serialize A
    long int addr = 0;
    for (int i = 0; i < I; i++)
    for (int k = 0; k < K; k++)
    for (int kk = 0; kk < KK; kk++)
    for (int ii = 0; ii < II; ii++)
    for (int iii = 0; iii < III/4; iii++)
    for (int kkk = 0; kkk < KKK; kkk++) {
        int total_k = kkk + KKK*kk + KKK*KK*k;
        int total_i = iii + III*ii + III*II*i;
        serialized_A_1[addr] = banded_A[total_k + TOTAL_K*total_i];
        serialized_A_2[addr] = banded_A[total_k + TOTAL_K*(total_i+III/4)];
        serialized_A_3[addr] = banded_A[total_k + TOTAL_K*(total_i+III/2)];
        serialized_A_4[addr] = banded_A[total_k + TOTAL_K*(total_i+3*III/4)];
        // serialized_A_1[addr] = total_k + total_i;
        // serialized_A_2[addr] = total_k + total_i+III/4;
        // serialized_A_3[addr] = total_k + total_i+III/2;
        // serialized_A_4[addr] = total_k + total_i+3*III/4;
        addr++;
    }
    // Serialize X
    addr = 0;
    int _linear_bnd = KK*KKK + II*III;
    for (int i = 0; i < I; i++)
    for (int k = 0; k < K; k++)
    for (int kk_ii_iii = 0; kk_ii_iii < _linear_bnd; kk_ii_iii++) {
        int _base = i * III*II + k * KKK*KK;
        serialized_X[addr] = X[_base + kk_ii_iii];
        // serialized_X[addr] = _base + kk_ii_iii;
        addr++;
    }
    // Serialize Y
    addr = 0;
    for (int i = 0; i < I; i++)
    for (int ii = 0; ii < II; ii++)
    for (int iii = 0; iii < III; iii++) {
        int total_i = iii + III*ii + III*II*i;
        serialized_Y[addr++] = Y[total_i];
    }

    DPRINTF("\n===== Host-CPU setting up the OpenCL platform and device ======\n\n");
    Options options(argc, argv);

    // Optional argument to specify whether the emulator should be used.
    bool use_emulator = false;
    if (options.has("emulator")) {
        use_emulator = options.get<bool>("emulator");
    }

    // Use this to check the output of each API call
    cl_int status;

    //----------------------------------------------
    // Discover and initialize the platforms
    //----------------------------------------------
    cl_platform_id platform = NULL;

    // Get the OpenCL platform.
    if (use_emulator) {
        platform = findPlatform("Intel(R) FPGA Emulation Platform for OpenCL(TM)");
    } else {
        platform = findPlatform("Intel(R) FPGA SDK for OpenCL(TM)");
    }
    if(platform == NULL) {
        printf("ERROR: Unable to find Intel(R) FPGA OpenCL platform.\n");
        return false;
    }
    // User-visible output - Platform information
    {
        char char_buffer[1024]; 
        printf("Querying platform for info:\n");
        printf("==========================\n");
        clGetPlatformInfo(platform, CL_PLATFORM_NAME, 1024, char_buffer, NULL);
        printf("%-40s = %s\n", "CL_PLATFORM_NAME", char_buffer);
        clGetPlatformInfo(platform, CL_PLATFORM_VENDOR, 1024, char_buffer, NULL);
        printf("%-40s = %s\n", "CL_PLATFORM_VENDOR ", char_buffer);
        clGetPlatformInfo(platform, CL_PLATFORM_VERSION, 1024, char_buffer, NULL);
        printf("%-40s = %s\n\n", "CL_PLATFORM_VERSION ", char_buffer);
    }

    //----------------------------------------------
    // Discover and initialize the devices
    //----------------------------------------------

    // Query the available OpenCL devices.
    scoped_array<cl_device_id> devices;
    cl_uint num_devices;
    cl_device_id device;

    devices.reset(getDevices(platform, CL_DEVICE_TYPE_ALL, &num_devices));

    // We'll just use the first device.
    device = devices[0];

    //----------------------------------------------
    // Create a context
    //----------------------------------------------
    cl_context context = NULL;
    // Create the context.
    context = clCreateContext(NULL, 1, &device, &oclContextCallback, NULL, &status);
    checkError(status, "Failed to create context");

    //----------------------------------------------
    // Create command queues
    //---------------------------------------------

    cl_command_queue cmdQueue[NUM_QUEUES_TO_CREATE + 1]; // extra queue for reading buffer D

    // Create a command queue using clCreateCommandQueue(),
    // and associate it with the device you want to execute on
    for (int i = 0; i < NUM_QUEUES_TO_CREATE; i++) {
        //fDPRINTF(stdout,"cmdQueue i = %d\n", i);
        cmdQueue[i] = clCreateCommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &status);
        CHECK(status);
    }

    //fDPRINTF(stdout,"cmdQueue i = %d, a queue for reading the C buffer\n", i);
    cmdQueue[NUM_QUEUES_TO_CREATE] = clCreateCommandQueue(
        context,
        devices[0],
        CL_QUEUE_PROFILING_ENABLE,
        &status);
    CHECK(status);

    //----------------------------------------------
    // Create device buffers
    //----------------------------------------------

    cl_mem input_A_buf_1, input_A_buf_2, input_A_buf_3, input_A_buf_4;
    cl_mem input_X_buf, input_Y_buf;
    cl_mem output_C_buf;

    DPRINTF("\n===== Host-CPU transferring W and X to the FPGA device global memory (DDR4) via PCIe ======\n\n");
    input_A_buf_1 = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_1_INTELFPGA,
        TOTAL_K * TOTAL_I / 4 * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    input_A_buf_2 = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_2_INTELFPGA,
        TOTAL_K * TOTAL_I / 4 * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    input_A_buf_3 = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_3_INTELFPGA,
        TOTAL_K * TOTAL_I / 4 * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    input_A_buf_4 = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_4_INTELFPGA,
        TOTAL_K * TOTAL_I / 4 * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    input_X_buf = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_AUTO_INTELFPGA,
        TOTAL_K * TOTAL_I * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    input_Y_buf = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_AUTO_INTELFPGA,
        TOTAL_I * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    output_C_buf = clCreateBuffer(
        context,
        CL_MEM_WRITE_ONLY | CL_CHANNEL_AUTO_INTELFPGA,
        TOTAL_I * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    //----------------------------------------------
    // Write host data to device buffers
    //----------------------------------------------

    // blocking writes
    status = clEnqueueWriteBuffer(
        cmdQueue[0],
        input_A_buf_1,
        CL_TRUE,
        0,
        TOTAL_K * TOTAL_I / 4 * sizeof(cl_float),
        serialized_A_1,
        0,
        NULL,
        NULL);
    CHECK(status);

    status = clEnqueueWriteBuffer(
        cmdQueue[0],
        input_A_buf_2,
        CL_TRUE,
        0,
        TOTAL_K * TOTAL_I / 4 * sizeof(cl_float),
        serialized_A_2,
        0,
        NULL,
        NULL);
    CHECK(status);

    status = clEnqueueWriteBuffer(
        cmdQueue[0],
        input_A_buf_3,
        CL_TRUE,
        0,
        TOTAL_K * TOTAL_I / 4 * sizeof(cl_float),
        serialized_A_3,
        0,
        NULL,
        NULL);
    CHECK(status);

    status = clEnqueueWriteBuffer(
        cmdQueue[0],
        input_A_buf_4,
        CL_TRUE,
        0,
        TOTAL_K * TOTAL_I / 4 * sizeof(cl_float),
        serialized_A_4,
        0,
        NULL,
        NULL);
    CHECK(status);

    status = clEnqueueWriteBuffer(
        cmdQueue[1],
        input_X_buf,
        CL_TRUE,
        0,
        TOTAL_K * TOTAL_I * sizeof(cl_float),
        serialized_X,
        0,
        NULL,
        NULL);
    CHECK(status);

    status = clEnqueueWriteBuffer(
        cmdQueue[1],
        input_Y_buf,
        CL_TRUE,
        0,
        TOTAL_I * sizeof(cl_float),
        serialized_Y,
        0,
        NULL,
        NULL);
    CHECK(status);

    //----------------------------------------------
    // Create the program from binaries
    //----------------------------------------------
    DPRINTF("\n===== Host-CPU setting up OpenCL program and kernels ======\n\n");

    cl_program program;
    char *aocx_file = getenv("BITSTREAM");
    printf("Using AOCX: %s\n", aocx_file);

    DPRINTF("Create program with binary\n");
    // Create a program using clCreateProgramWithBinary()
    program = createProgramFromBinary(context, aocx_file, &device, 1);

    //----------------------------------------------
    // Create the kernel
    //----------------------------------------------

    status = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
    CHECK(status);

    cl_kernel kernel[NUM_KERNELS_TO_CREATE];
    for (int j = 0; j < NUM_KERNELS_TO_CREATE; j++) {
        DPRINTF("Creating kernel[%d]: %s\n", j, kernel_name[j]);
        kernel[j] = clCreateKernel(program, (const char *)kernel_name[j], &status);
        CHECK(status);
    }
    DPRINTF("All kernels created\n");

    // A_loader
    status = clSetKernelArg(
        kernel[0],
        0,
        sizeof(int),
        (void *)&TOTAL_K);
    CHECK(status);
    status = clSetKernelArg(
        kernel[0],
        1,
        sizeof(int),
        (void *)&TOTAL_I);
    CHECK(status);
    status = clSetKernelArg(
        kernel[0],
        2,
        sizeof(cl_mem),
        (void *)&input_A_buf_1);
    CHECK(status);
    status = clSetKernelArg(
        kernel[0],
        3,
        sizeof(cl_mem),
        (void *)&input_A_buf_2);
    CHECK(status);
    status = clSetKernelArg(
        kernel[0],
        4,
        sizeof(cl_mem),
        (void *)&input_A_buf_3);
    CHECK(status);
    status = clSetKernelArg(
        kernel[0],
        5,
        sizeof(cl_mem),
        (void *)&input_A_buf_4);
    CHECK(status);
    // X_loader
    status = clSetKernelArg(
        kernel[1],
        0,
        sizeof(int),
        (void *)&TOTAL_K);
    CHECK(status);
    status = clSetKernelArg(
        kernel[1],
        1,
        sizeof(int),
        (void *)&TOTAL_I);
    CHECK(status);
    status = clSetKernelArg(
        kernel[1],
        2,
        sizeof(cl_mem),
        (void *)&input_X_buf);
    CHECK(status);
    // X_feeder
    status = clSetKernelArg(
        kernel[2],
        0,
        sizeof(int),
        (void *)&TOTAL_K);
    CHECK(status);
    status = clSetKernelArg(
        kernel[2],
        1,
        sizeof(int),
        (void *)&TOTAL_I);
    CHECK(status);
    // kernel_V
    status = clSetKernelArg(
        kernel[3],
        0,
        sizeof(int),
        (void *)&TOTAL_K);
    CHECK(status);
    status = clSetKernelArg(
        kernel[3],
        1,
        sizeof(int),
        (void *)&TOTAL_I);
    CHECK(status);
    // kernel_yLoader
    status = clSetKernelArg(
        kernel[4],
        0,
        sizeof(int),
        (void *)&TOTAL_I);
    CHECK(status);
    status = clSetKernelArg(
        kernel[4],
        1,
        sizeof(cl_mem),
        (void *)&input_Y_buf);
    CHECK(status);
    // kernel_Out
    status = clSetKernelArg(
        kernel[5],
        0,
        sizeof(int),
        (void *)&TOTAL_I);
    CHECK(status);
    status = clSetKernelArg(
        kernel[5],
        1,
        sizeof(int),
        (void *)&alpha);
    CHECK(status);
    status = clSetKernelArg(
        kernel[5],
        2,
        sizeof(int),
        (void *)&beta);
    CHECK(status);
    // unloader
    status = clSetKernelArg(
        kernel[6],
        0,
        sizeof(int),
        (void *)&TOTAL_I);
    CHECK(status);
    status = clSetKernelArg(
        kernel[6],
        1,
        sizeof(cl_mem),
        (void *)&output_C_buf);
    CHECK(status);

    //----------------------------------------------
    // Configure the work-item structure (using only tasks atm)
    //----------------------------------------------
    size_t globalWorkSize[1];
    size_t localWorkSize[1];
    globalWorkSize[0] = 1;
    localWorkSize[0] = 1;

    cl_event kernel_exec_event[NUM_KERNELS_TO_CREATE];

    DPRINTF("\n===== Host-CPU enqeuing the OpenCL kernels to the FPGA device ======\n\n");
    for (int i = 0; i < NUM_KERNELS_TO_CREATE; i++) {
        // Alternatively, can use clEnqueueTaskKernel
        DPRINTF("clEnqueueNDRangeKernel[%d]: %s!\n", i, kernel_name[i]);
        status = clEnqueueNDRangeKernel(
            cmdQueue[i],
            kernel[i],
            1,
            NULL,
            globalWorkSize,
            localWorkSize,
            0,
            NULL,
            &kernel_exec_event[i]);
        CHECK(status);
    }
    DPRINTF(" *** FPGA execution started!\n");

    for (int i = 0; i < NUM_KERNELS_TO_CREATE; i++) {
        status = clFlush(cmdQueue[i]);
        CHECK(status);
    }

    for (int i = 0; i < NUM_QUEUES_TO_CREATE; i++) {
        DPRINTF("cmd queue: %d\n", i);
        fflush(stdout);
        status = clFinish(cmdQueue[i]);
        CHECK(status);
    }
    DPRINTF(" *** FPGA execution finished!\n");
    DPRINTF("\n\n");

    double k_start_time[NUM_KERNELS_TO_CREATE];
    double k_end_time[NUM_KERNELS_TO_CREATE];
    double k_exec_time[NUM_KERNELS_TO_CREATE];
    double max_time = 0;
    for (int i = 0; i < NUM_KERNELS_TO_CREATE; i++) {
        k_exec_time[i] = compute_kernel_execution_time(kernel_exec_event[i], k_start_time[i], k_end_time[i]);
        if (k_exec_time[i] > max_time) {
            max_time = k_exec_time[i];
        }
    }
    DPRINTF("Time taken: %lf sec\n\n", max_time);

    printf("\n===== Reporting measured throughput ======\n\n");
    double k_earliest_start_time = k_start_time[0];
    double k_latest_end_time = k_end_time[0];

    for (int i = 1; i < NUM_KERNELS_TO_CREATE; i++) {
        if (k_start_time[i] < k_earliest_start_time)
            k_earliest_start_time = k_start_time[i];

        if (k_end_time[i] > k_latest_end_time)
            k_latest_end_time = k_end_time[i];
    }

    // IMPORTANT: we care about the finish time of drain_C, once data is drained we are done
    k_latest_end_time = k_end_time[NUM_KERNELS_TO_CREATE - 1];

    for (int i = 0; i < NUM_KERNELS_TO_CREATE; i++) {
        printf("  Kernel execution time on FPGA: %s, \n   \t\t\t\t\t\t\t\t\texec time = %.5f s, start=%.5f s, end=%.5f s\n", kernel_name[i], k_exec_time[i], k_start_time[i], k_end_time[i]);
    }

    double k_overall_exec_time = k_latest_end_time - k_earliest_start_time;

    printf("\n");
    printf("  Loader kernels start time\t\t= %.5f s\n", k_earliest_start_time);
    printf("  Unloader kernels end time\t\t= %.5f s\n", k_latest_end_time);
    printf("  FPGA GEMM exec time\t\t= %.5f s\n", k_overall_exec_time);

    // multiplied by 1.0e-9 to get G-FLOPs
    printf("\n");

    double num_operations = (double)2.0 * (TOTAL_J) * (double)(TOTAL_I);

    printf("  # operations = %.0f\n", num_operations );
    printf("  Throughput: %.5f GFLOPS\n", (double)1.0e-9 * num_operations / k_overall_exec_time);

    DPRINTF("\n===== Host-CPU transferring result matrix C from the FPGA device global memory (DDR4) via PCIe ======\n\n");

    // Read the results back from the device, blocking read
    float *C;
    if ((C = (float *)acl_aligned_malloc(TOTAL_I * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix C");
    }

    clEnqueueReadBuffer(
        //cmdQueue[KID_DRAIN_MAT_C],
        cmdQueue[NUM_KERNELS_TO_CREATE], // using a special queue for reading buffer C
        output_C_buf,
        CL_TRUE,
        0,
        TOTAL_I * sizeof(cl_float),
        C,
        0,
        NULL,
        NULL);
    CHECK(status);

    bool passed = 1;
    // Validate the results
    for (int i = 0; i < I; i++)
    for (int ii = 0; ii < II; ii++)
    for (int iii = 0; iii < III; iii++) {
        // printf("verify %d %f\n", i * 2 + iii, o(0, iii, ii, i));
        int total_i = iii + III * ii + III * II * i;
        if (total_i < 0 || total_i >= TOTAL_I) continue;

        float golden = 0;
        // cout << "y beta " << y(total_i + Ku) << " " << beta << " " << golden << endl;
        for (int j = 0; j < TOTAL_J; j++) {
            if (j - total_i > Ku || total_i - j > Kl) continue;
            golden += A[j + TOTAL_J*total_i] * X[j+Ku];
        }
        golden = golden * alpha + Y[total_i] * beta;

        // std::cout << "(" << i << "," << ii << "," << iii << ") " << golden << " " << C[total_i] << std::endl;
        passed &= fabs(golden - C[total_i]) <= 0.005*fabs(golden);
        assert(fabs(golden - C[total_i]) <= 0.005*fabs(golden));
    }

    if (passed) {
        printf("[PASSED]\n");
    } else {
        printf("[FAILED]\n");
    }
}

