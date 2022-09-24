#!/bin/bash

function cleanup {
    rm -rf a.* a/ ${workload}-interface.* *.out exec_time.txt *.png *.o *.isa ${workload}_genx.cpp signed* temp* profile.mon
}

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

function setup_env {
    source ../../../../../../setenv.sh $location fpga
}

function synthesize_fpga_kernel {
    setup_env
    cleanup

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
        
    g++ t2s-${workload:1}-spec.cpp -g -DCONST_TYPE=$CONST_TYPE -DTTYPE=$TTYPE -I $T2S_PATH/Halide/include -L $T2S_PATH/Halide/bin $(libhalide_to_link) -lz -lpthread -ldl -std=c++11 \
        -DSIZE=${size^^} -DPREFIXES=${prefixes^^} -DTARGET=${target^^}

    # Generate a device kernel, and a C interface for the host to invoke the kernel:
    # The bitstream generated is a.aocx, as indicated by the environment variable, BITSTREAM.
    # The C interface generated is ${workload}-interface.cpp, as specified in ${workload}.cpp.
    bitstream="$workload.aocx"
    env BITSTREAM=$bitstream AOC_OPTION="$(aoc_options)" ./a.out

    # DevCloud A10PAC (1.2.1) only: further convert the signed bitstream to unsigned:
    if [ "$target" == "a10" -a "$platform" == "hw" ]; then
        cp $bitstream a_signed.aocx # Keep a signed copy in case the conversion fails below and we can look at the issue manually
        { echo "Y"; echo "Y"; echo "Y"; echo "Y"; } | source $AOCL_BOARD_PACKAGE_ROOT/linux64/libexec/sign_aocx.sh -H openssl_manager -i $bitstream -r NULL -k NULL -o a_unsigned.aocx
        mv a_unsigned.aocx $bitstream
    fi
}