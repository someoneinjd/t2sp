#!/bin/bash
set +x

RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'

# In this array, every element contains:
#  Test name

array=(
        "complex-buffer.cpp"
        "complex-param.cpp"
        "complex-const.cpp"
        "complex-img.cpp"
        "complex-fpga.cpp"
        "complex-extern.cpp"
      )

succ=0
fail=0

function test_func {
    eval file="$1"
    target_option=" CL_CONTEXT_EMULATOR_DEVICE_INTELFPGA=1 INTEL_FPGA_OCL_PLATFORM_NAME="$EMULATOR_PLATFORM" AOC_OPTION="\""$EMULATOR_AOC_OPTION -board=$FPGA_BOARD"\"" "
    compile="g++ $file -O0 -g -I ../util  -I ../../../../Halide/include -L ../../../../Halide/bin $EMULATOR_LIBHALIDE_TO_LINK -lz -lpthread -ldl -std=c++11 -DSIZE=10 -DVERBOSE_DEBUG "
    run="env $target_option ./a.out"
    clean="rm -rf a a.out $HOME/tmp/a.aocx $HOME/tmp/a.aocr $HOME/tmp/a.aoco $HOME/tmp/a.cl $HOME/tmp/a"
    $clean
    $compile >& a
    if [ -f "a.out" ]; then        
        # There is an error "Unterminated quoted string" using $run due to BITSTREAM and AOC_OPTION. To avoid it, explicitly run for every case.
        rm -f a
        timeout 5m env CL_CONTEXT_EMULATOR_DEVICE_INTELFPGA=1 INTEL_FPGA_OCL_PLATFORM_NAME="$EMULATOR_PLATFORM" AOC_OPTION="$EMULATOR_AOC_OPTION -board=$FPGA_BOARD" ./a.out >& a

        if  tail -n 1 a | grep -q -E "^Success!"; then
            echo >> success.txt
            echo $clean >> success.txt
            echo $compile >> success.txt
            echo $run >> success.txt
            cat a >> success.txt
            let succ=succ+1
            echo " Success!"
        else
            echo >> failure.txt
            echo $clean >> failure.txt
            echo $compile >> failure.txt
            echo $run >> failure.txt
            cat a >> failure.txt
            let fail=fail+1
            echo "Failure!"
        fi
    else
        echo >> failure.txt
        echo $clean >> failure.txt
        echo $compile >> failure.txt
        cat a >> failure.txt
        let fail=fail+1
        echo " Failure!"
    fi 
}
        
echo "Testing FPGA target."
rm -rf success.txt failure.txt exec_time.txt a $HOME/tmp/a.*
index=0
while [ "$index" -lt "${#array[*]}" ]; do
   file=${array[$index]}
   let index=index+1
   printf "Case: $file"
   test_func "\${file}"
done

let total=succ+fail
echo -e Total $total, pass ${GREEN}$succ${NOCOLOR}, fail ${RED}$fail${NOCOLOR}. See $PWD/success.txt and failure.txt for details.

# Return values for the parent script
echo $total > ../total.temp
echo $succ > ../succ.temp
echo $fail > ../fail.temp