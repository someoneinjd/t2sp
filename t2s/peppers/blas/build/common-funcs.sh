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
    elif [ "$prefixes" == "z" ]; then
        CONST_TYPE="complex64_t" 
        TTYPE="Complex(64)"
    else
        echo TODO: HANDLE other prefixes!
    fi      
        
g++ kernel.cpp -g -DCONST_TYPE=$CONST_TYPE -DTTYPE=$TTYPE -DINTERFACE_FILE=\"${workload}-interface\" -DKERNEL=\"tblas_${workload}\" -I $T2S_PATH/Halide/include -L $T2S_PATH/Halide/bin $(libhalide_to_link) -lz -lpthread -ldl -std=c++11 \
        -D${size^^} -D${prefixes^^} -D${target^^} -o kernel.out

    # Generate a device kernel, and a C interface for the host to invoke the kernel:
    # The bitstream generated is kernel.aocx.
    # The C interface generated is ${workload}-interface.cpp, as specified in ${workload}.cpp.
    bitstream="kernel.aocx"
    env BITSTREAM=$bitstream AOC_OPTION="$(aoc_options)" ./kernel.out

    # DevCloud A10PAC (1.2.1) only: further convert the signed bitstream to unsigned:
    if [ "$location" == "devcloud" -a "$target" == "a10" -a "$platform" == "hw" ]; then
        { echo "Y"; echo "Y"; echo "Y"; echo "Y"; } | source $AOCL_BOARD_PACKAGE_ROOT/linux64/libexec/sign_aocx.sh -H openssl_manager -i $bitstream -r NULL -k NULL -o unsigned.aocx
        mv unsigned.aocx $bitstream
    fi
}
