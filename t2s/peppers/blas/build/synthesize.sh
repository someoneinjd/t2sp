#!/bin/sh
set -x

# BASH_SOURCE is this script
if [ $0 != $BASH_SOURCE ]; then
    echo "Error: The script should be directly run, not sourced"
    return
fi

# Path to this script
PATH_TO_SCRIPT="$( cd "$(dirname "$BASH_SOURCE" )" >/dev/null 2>&1 ; pwd -P )" # The path to this script

cur_dir=$PWD

cd $PATH_TO_SCRIPT
source ./common-funcs.sh
source ./parse-options.sh $@
if [ "$wrong_options" != "0" ]; then
    echo "Error: wrong options encountered"
    exit
fi

# Copy kernel source to the build directory
mkdir -p ${level} ${level}/${workload}
rm -rf ${level}/${workload}/*
cp -rf ../src/${level}/${workload:${#prefixes}}/* ${level}/${workload}

cd ${level}/${workload}

echo ------------------- Synthesizing $@
source $T2S_PATH/setenv.sh $location fpga
synthesize_fpga_kernel

mkdir -p $PATH_TO_SCRIPT/../bin/${level} $PATH_TO_SCRIPT/../bin/${level}/${workload}
cp -f $PATH_TO_SCRIPT/${level}/${workload}/kernel.aocx $PATH_TO_SCRIPT/../bin/${level}/${workload}
cp -f $PATH_TO_SCRIPT/${level}/${workload}/kernel-interface.o $PATH_TO_SCRIPT/../bin/${level}/${workload}

cd $cur_dir

