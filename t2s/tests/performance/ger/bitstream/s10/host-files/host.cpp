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
#include "AOCLUtils/aocl_utils.h"
#include "CL/opencl.h"
#include "CL/cl_ext_intelfpga.h"
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <math.h>
#include <sstream>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <sys/time.h>
#include <time.h>

#include "const-parameters.h"
#define I   1024
#define J   1024

using namespace aocl_utils;

#define TYPE float

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#define DPRINTF(...)     \
    printf(__VA_ARGS__); \
    fflush(stdout);

#define NUM_QUEUES_TO_CREATE    5
#define NUM_KERNELS_TO_CREATE   5

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
    "kernel_xLoader",
    "kernel_yLoader",
    "kernel_aLoader",
    "kernel_uZ",
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


int main() {
    float *A, *X, *Y;
    const int TOTAL_I = II * I;
    const int TOTAL_J = JJ * J;

    if ((A = (float *)acl_aligned_malloc(TOTAL_I*TOTAL_J * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix A");
    }
    if ((X = (float *)acl_aligned_malloc(TOTAL_I * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix A");
    }
    if ((Y = (float *)acl_aligned_malloc(TOTAL_J * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix A");
    }
    for (size_t i = 0; i < TOTAL_I; i++) {
        for (size_t j = 0; j < TOTAL_J; j++) {
            A[j + i*TOTAL_J] = random();
        }
    }
    for (size_t i = 0; i < TOTAL_I; i++) {
        X[i] = random();
    }
    for (size_t j = 0; j < TOTAL_J; j++) {
        Y[j] = random();
    }

    float *serialized_A_1, *serialized_A_2, *serialized_X, *serialized_Y;
    if ((serialized_A_1 = (float *)acl_aligned_malloc(TOTAL_I*TOTAL_J/2 * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix serialized_A");
    }
    if ((serialized_A_2 = (float *)acl_aligned_malloc(TOTAL_I*TOTAL_J/2 * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix serialized_A");
    }
    if ((serialized_X = (float *)acl_aligned_malloc(TOTAL_I * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix serialized_A");
    }
    if ((serialized_Y = (float *)acl_aligned_malloc(TOTAL_J * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix serialized_A");
    }

    // Serialize A
    long int addr = 0;
    for (int i = 0; i < I; i++)
    for (int j = 0; j < J; j++)
    for (int ii = 0; ii < II; ii++)
    for (int jj = 0; jj < JJ/2; jj++) {
        int total_j = jj + JJ*j;
        int total_i = ii + II*i;
        serialized_A_1[addr] = A[total_j + TOTAL_J*total_i];
        serialized_A_2[addr] = A[(total_j+JJ/2) + TOTAL_J*total_i];
        addr++;
    }
    // Serialize X
    addr = 0;
    for (int i = 0; i < TOTAL_I; i++) {
        serialized_X[addr++] = X[i];
    }
    // Serialize Y
    addr = 0;
    for (int j = 0; j < TOTAL_J; j++) {
        serialized_Y[addr++] = Y[j];
    }


    DPRINTF("\n===== Host-CPU setting up the OpenCL platform and device ======\n\n");

    // Use this to check the output of each API call
    cl_int status;

    //----------------------------------------------
    // Discover and initialize the platforms
    //----------------------------------------------
    cl_uint numPlatforms = 0;
    cl_platform_id *platforms = NULL;

    // Use clGetPlatformIDs() to retrieve the
    // number of platforms
    status = clGetPlatformIDs(0, NULL, &numPlatforms);
    DPRINTF("Number of platforms = %d\n", numPlatforms);

    // Allocate enough space for each platform
    // platforms = (cl_platform_id*) acl_aligned_malloc (numplatforms * sizeof(cl_platform_id));
    platforms = (cl_platform_id *)malloc(numPlatforms * sizeof(cl_platform_id));

    DPRINTF("Allocated space for Platform\n");

    // Fill in platforms with clGetPlatformIDs()
    status = clGetPlatformIDs(numPlatforms, platforms, NULL);
    CHECK(status);
    DPRINTF("Filled in platforms\n");

    //----------------------------------------------
    // Discover and initialize the devices
    //----------------------------------------------

    cl_uint numDevices = 0;

    // Device info
    char buffer[4096];
    unsigned int buf_uint;
    int device_found = 0;
    const cl_uint maxDevices = 4;
    cl_device_id devices[maxDevices];
    DPRINTF("Initializing IDs\n");
    for (int i = 0; i < numPlatforms; i++) {
        status = clGetDeviceIDs(platforms[i],
                                CL_DEVICE_TYPE_ALL,
                                maxDevices,
                                devices,
                                &numDevices);

        if (status == CL_SUCCESS) {
            clGetPlatformInfo(platforms[i],
                              CL_PLATFORM_NAME,
                              4096,
                              buffer,
                              NULL);
#if defined(ALTERA_CL)
            if (strstr(buffer, "Altera") != NULL) {
                device_found = 1;
            }
            DPRINTF("%s\n", buffer);
#elif defined(NVIDIA_CL)
            if (strstr(buffer, "NVIDIA") != NULL) {
                device_found = 1;
            }
#else
            if (strstr(buffer, "Intel") != NULL) {
                device_found = 1;
            }
#endif
            DPRINTF("Platform found : %s\n", buffer);
            device_found = 1;
        }
    }

    if (!device_found) {
        DPRINTF("failed to find a OpenCL device\n");
        exit(-1);
    }

    DPRINTF("Total number of devices: %d", numDevices);
    for (int i = 0; i < numDevices; i++) {
        clGetDeviceInfo(devices[i],
                        CL_DEVICE_NAME,
                        4096,
                        buffer,
                        NULL);
        DPRINTF("\nDevice Name: %s\n", buffer);

        clGetDeviceInfo(devices[i],
                        CL_DEVICE_VENDOR,
                        4096,
                        buffer,
                        NULL);
        DPRINTF("Device Vendor: %s\n", buffer);

        clGetDeviceInfo(devices[i],
                        CL_DEVICE_MAX_COMPUTE_UNITS,
                        sizeof(buf_uint),
                        &buf_uint,
                        NULL);
        DPRINTF("Device Computing Units: %u\n", buf_uint);

        clGetDeviceInfo(devices[i],
                        CL_DEVICE_GLOBAL_MEM_SIZE,
                        sizeof(unsigned long),
                        &buffer,
                        NULL);
        //DPRINTF("Global Memory Size: %i\n", *((unsigned long*)buffer));

        clGetDeviceInfo(devices[i],
                        CL_DEVICE_MAX_MEM_ALLOC_SIZE,
                        sizeof(unsigned long),
                        &buffer,
                        NULL);
        //DPRINTF("Global Memory Allocation Size: %i\n\n", *((unsigned long*)buffer));
    }

    //----------------------------------------------
    // Create a context
    //----------------------------------------------

    DPRINTF("\n===== Host-CPU setting up the OpenCL command queues ======\n\n");

    cl_context context = NULL;

    // Create a context using clCreateContext() and
    // associate it with the device

    context = clCreateContext(
        NULL,
        1,
        devices,
        NULL,
        NULL,
        &status);
    CHECK(status);

    //----------------------------------------------
    // Create command queues
    //---------------------------------------------

    cl_command_queue cmdQueue[NUM_QUEUES_TO_CREATE + 1]; // extra queue for reading buffer D

    // Create a command queue using clCreateCommandQueue(),
    // and associate it with the device you want to execute on
    for (int i = 0; i < NUM_QUEUES_TO_CREATE; i++) {
        //fDPRINTF(stdout,"cmdQueue i = %d\n", i);
        cmdQueue[i] = clCreateCommandQueue(
            context,
            devices[0],
            CL_QUEUE_PROFILING_ENABLE,
            &status);
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

    cl_mem input_A_buf_1, input_A_buf_2;
    cl_mem input_X_buf;
    cl_mem input_Y_buf;
    cl_mem output_C_buf_1, output_C_buf_2;

    DPRINTF("\n===== Host-CPU transferring W and X to the FPGA device global memory (DDR4) via PCIe ======\n\n");
    input_A_buf_1 = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_1_INTELFPGA,
        TOTAL_J * TOTAL_I/2 * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    input_A_buf_2 = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_2_INTELFPGA,
        TOTAL_J * TOTAL_I/2 * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    input_X_buf = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_AUTO_INTELFPGA,
        TOTAL_I * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    input_Y_buf = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_AUTO_INTELFPGA,
        TOTAL_J * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    output_C_buf_1 = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_3_INTELFPGA,
        TOTAL_J * TOTAL_I/2 * sizeof(cl_float),
        NULL,
        &status);
    CHECK(status);

    output_C_buf_2 = clCreateBuffer(
        context,
        CL_MEM_READ_ONLY | CL_CHANNEL_4_INTELFPGA,
        TOTAL_J * TOTAL_I/2 * sizeof(cl_float),
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
        TOTAL_J * TOTAL_I/2 * sizeof(cl_float),
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
        TOTAL_J * TOTAL_I/2 * sizeof(cl_float),
        serialized_A_2,
        0,
        NULL,
        NULL);
    CHECK(status);

    status = clEnqueueWriteBuffer(
        cmdQueue[1],
        input_X_buf,
        CL_TRUE,
        0,
        TOTAL_I * sizeof(cl_float),
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
        TOTAL_J * sizeof(cl_float),
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

    size_t binary_length;
    const unsigned char *binary;

    fflush(stdout);
    // create the program using binary already compiled offline using aoc (i.e. the .aocx file)
    char *aocx_file = getenv("BITSTREAM");
    FILE *fp = fopen(aocx_file, "rb");

    if (fp == NULL) {
        DPRINTF("Failed to open the AOCX file (fopen).\n");
        return -1;
    }

    fseek(fp, 0, SEEK_END);
    binary_length = ftell(fp);
    binary = (unsigned char *)malloc(sizeof(unsigned char) * binary_length);
    assert(binary && "Malloc failed");
    rewind(fp);

    if (fread((void *)binary, binary_length, 1, fp) == 0) {
        DPRINTF("Failed to read from the AOCX file (fread).\n");
        return -1;
    }
    fclose(fp);

    DPRINTF("Create program with binary\n");
    // Create a program using clCreateProgramWithBinary()
    program = clCreateProgramWithBinary(
        context,
        1,
        devices,
        &binary_length,
        (const unsigned char **)&binary,
        &status,
        NULL);
    CHECK(status);

    //----------------------------------------------
    // Create the kernel
    //----------------------------------------------

    status = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
    if (status != CL_SUCCESS) {
        char log[128 * 1024] = {0};
        clGetProgramBuildInfo(program, devices[0], CL_PROGRAM_BUILD_LOG, 128 * 1024, log, NULL);
        DPRINTF("%s\n", log);
        CHECK(status);
    }

    cl_kernel kernel[NUM_KERNELS_TO_CREATE];

    for (int j = 0; j < NUM_KERNELS_TO_CREATE; j++) {
        DPRINTF("Creating kernel[%d]: %s\n", j, kernel_name[j]);
        kernel[j] = clCreateKernel(program, (const char *)kernel_name[j], &status);
        CHECK(status);
    }
    DPRINTF("All kernels created\n");

    // X_loader
    status = clSetKernelArg(
        kernel[0],
        0,
        sizeof(int),
        (void *)&TOTAL_J);
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
        (void *)&input_X_buf);
    CHECK(status);
    // Y_loader
    status = clSetKernelArg(
        kernel[1],
        0,
        sizeof(int),
        (void *)&TOTAL_J);
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
        (void *)&input_Y_buf);
    CHECK(status);
    // A_feeder
    status = clSetKernelArg(
        kernel[2],
        0,
        sizeof(int),
        (void *)&TOTAL_J);
    CHECK(status);
    status = clSetKernelArg(
        kernel[2],
        1,
        sizeof(int),
        (void *)&TOTAL_I);
    CHECK(status);
    status = clSetKernelArg(
        kernel[2],
        2,
        sizeof(cl_mem),
        (void *)&input_A_buf_1);
    CHECK(status);
    status = clSetKernelArg(
        kernel[2],
        3,
        sizeof(cl_mem),
        (void *)&input_A_buf_2);
    CHECK(status);
    // kernel_uZ
    status = clSetKernelArg(
        kernel[3],
        0,
        sizeof(int),
        (void *)&TOTAL_J);
    CHECK(status);
    status = clSetKernelArg(
        kernel[3],
        1,
        sizeof(int),
        (void *)&TOTAL_I);
    CHECK(status);
    // unloader
    status = clSetKernelArg(
        kernel[4],
        0,
        sizeof(int),
        (void *)&TOTAL_J);
    CHECK(status);
    status = clSetKernelArg(
        kernel[4],
        1,
        sizeof(int),
        (void *)&TOTAL_I);
    CHECK(status);
    status = clSetKernelArg(
        kernel[4],
        2,
        sizeof(cl_mem),
        (void *)&output_C_buf_1);
    CHECK(status);
    status = clSetKernelArg(
        kernel[4],
        3,
        sizeof(cl_mem),
        (void *)&output_C_buf_2);
    CHECK(status);

    //----------------------------------------------
    // Configure the work-item structure (using only tasks atm)
    //----------------------------------------------

    // Define the number of threads that will be created
    // as well as the number of work groups
    size_t globalWorkSize[1];
    size_t localWorkSize[1];

    //----------------------------------------------
    // Enqueue the kernel for execution
    //----------------------------------------------

    // all kernels are always tasks
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
    float *C_1, *C_2;
    if ((C_1 = (float *)acl_aligned_malloc(TOTAL_I * TOTAL_J/2 * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix C");
    }
    if ((C_2 = (float *)acl_aligned_malloc(TOTAL_I * TOTAL_J/2 * sizeof(float))) == NULL) {
        perror("Failed malloc of matrix C");
    }

    clEnqueueReadBuffer(
        //cmdQueue[KID_DRAIN_MAT_C],
        cmdQueue[NUM_KERNELS_TO_CREATE], // using a special queue for reading buffer C
        output_C_buf_1,
        CL_TRUE,
        0,
        TOTAL_I * TOTAL_J/2 * sizeof(cl_float),
        C_1,
        0,
        NULL,
        NULL);
    CHECK(status);

    clEnqueueReadBuffer(
        //cmdQueue[KID_DRAIN_MAT_C],
        cmdQueue[NUM_KERNELS_TO_CREATE], // using a special queue for reading buffer C
        output_C_buf_2,
        CL_TRUE,
        0,
        TOTAL_I * TOTAL_J/2 * sizeof(cl_float),
        C_2,
        0,
        NULL,
        NULL);
    CHECK(status);

    bool passed = 1;
    int addr_1 = 0, addr_2 = 0;
    for (size_t i = 0; i < I; i++)
    for (size_t j = 0; j < J; j++)
    for (size_t ii = 0; ii < II; ii++) {
        for (size_t jj = 0; jj < JJ/2; jj++) {
            size_t total_i = ii + II * i;
            size_t total_j = jj + JJ * j;
            float golden = X[total_i] * Y[total_j];
            golden += A[total_j + TOTAL_J*total_i];
            passed &= fabs(golden - C_1[addr_1]) < 0.005*fabs(golden);
            addr_1 += 1;
        }
        for (size_t jj = JJ/2; jj < JJ; jj++) {
            size_t total_i = ii + II * i;
            size_t total_j = jj + JJ * j;
            float golden = X[total_i] * Y[total_j];
            golden += A[total_j + TOTAL_J*total_i];
            passed &= fabs(golden - C_2[addr_2]) < 0.005*fabs(golden);
            addr_2 += 1;
        }
    }

    if (passed) {
        printf("[PASSED]\n");
    } else {
        printf("[FAILED]\n");
    }
}

