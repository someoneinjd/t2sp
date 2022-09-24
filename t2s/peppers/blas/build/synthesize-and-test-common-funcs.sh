#!/bin/bash

function libhalide_to_link {
    if [ "$platform" == "emulator" ]; then
        lib="$EMULATOR_LIBHALIDE_TO_LINK"
    else
        lib="$HW_LIBHALIDE_TO_LINK"
    fi
    echo "$lib"
}

function aoc_options {
    if [ "$platform" == "emulator" ]; then
        aoc_opt="$EMULATOR_AOC_OPTION -board=$FPGA_BOARD -emulator-channel-depth-model=strict"
    else
        aoc_opt="-v -profile -fpc -fp-relaxed -high-effort -board=$FPGA_BOARD"
    fi
    echo "$aoc_opt"
}

function synthesize_fpga_kernel {
    # Compile the specification
    if [ "$prefixes" == "s" ]; then
        CONST_TYPE="float" 
        TTYPE="Float(32)"
    elif [ "$prefixes" == "d" ]; then
        CONST_TYPE="double" 
        TTYPE="Float(64)"
    elif [ "$prefixes" == "c" ]; then
        CONST_TYPE="complex32_t" 
        TTYPE="Complex(32)"
    else
        #todo: CHECK other prefixes
        CONST_TYPE="complex64_t" 
        TTYPE="Complex(64)"
    fi      
        
    g++ kernel.cpp -g -DCONST_TYPE=$CONST_TYPE -DTTYPE=$TTYPE -I $T2S_PATH/Halide/include -L $T2S_PATH/Halide/bin $(libhalide_to_link) -lz -lpthread -ldl -std=c++11 \
        -DSIZE=${size^^} -DPREFIXES=${prefixes^^} -DTARGET=${target^^} -o kernel.out

    # Generate a device kernel, and a C interface for the host to invoke the kernel:
    # The bitstream generated is a.aocx, as indicated by the environment variable, BITSTREAM.
    # The C interface generated is ${workload}-interface.cpp, as specified in ${workload}.cpp.
    bitstream="kernel.aocx"
    env BITSTREAM=$bitstream AOC_OPTION="$(aoc_options)" ./kernel.out

    # DevCloud A10PAC (1.2.1) only: further convert the signed bitstream to unsigned:
    if [ "$target" == "a10" -a "$platform" == "hw" ]; then
        { echo "Y"; echo "Y"; echo "Y"; echo "Y"; } | source $AOCL_BOARD_PACKAGE_ROOT/linux64/libexec/sign_aocx.sh -H openssl_manager -i $bitstream -r NULL -k NULL -o unsigned.aocx
        mv unsigned.aocx $bitstream
    fi
}

function test_fpga_kernel {
    # Compile the host file (${workload}-run-fpga.cpp) and link with the C interface (${workload}-interface.cpp):
    g++ ${workload}-run-fpga.cpp ${workload}-interface.cpp ../../../src/AOT-OpenCL-Runtime.cpp ../../../src/Roofline.cpp ../../../src/SharedUtilsInC.cpp  -g -DLINUX -DALTERA_CL -fPIC -I ../util -I../../../src/ -I $T2S_PATH/Halide/include -I../../../src/AOCLUtils ../../../src/AOCLUtils/opencl.cpp $(aocl compile-config) $(aocl link-config) -L $T2S_PATH/Halide/bin -lelf $(libhalide_to_link) -D$size -lz -lpthread -ldl -std=c++11 -o ./b.out

    if [ "$platform" == "emulator" ]; then
        env BITSTREAM="$bitstream" CL_CONTEXT_EMULATOR_DEVICE_INTELFPGA=1 INTEL_FPGA_OCL_PLATFORM_NAME="$EMULATOR_PLATFORM" ./b.out
    else
        # Offload the bitstream to the device.
        aocl program acl0 "$bitstream"

        # Run the host binary. The host offloads the bitstream to an FPGA and invokes the kernel through the interface:
        env BITSTREAM="$bitstream" INTEL_FPGA_OCL_PLATFORM_NAME="$HW_PLATFORM" ./b.out
    fi
}
