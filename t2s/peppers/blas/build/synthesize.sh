#set -x

# BASH_SOURCE is this script
#if [ $0 != $BASH_SOURCE ]; then
#    echo "Error: The script should be directly run, not sourced"
#    return
#fi

# Path to this script
PATH_TO_SCRIPT="$( cd "$(dirname "$BASH_SOURCE" )" >/dev/null 2>&1 ; pwd -P )" # The path to this script

cur_dir=$PWD

cd $PATH_TO_SCRIPT
source ./synthesize-and-test-common-funcs.sh
source ./parse-options.sh $@
if [ "$wrong_options" != "0" ]; then
    echo "Error: wrong options encountered"
    exit
fi

# Copy kernel source to the build directory
mkdir -p ${level}/${workload}
rm -rf ${level}/${workload}/*
cp -rf ../src/${level}/${workload:1}/* ${level}/${workload}

cd ${level}/${workload}

echo ------------------- Synthesizing $@
synthesize_fpga_kernel

echo ------------------- Copying binaries to bin directory
cd $PATH_TO_SCRIPT
mkdir -p ../bin/${level}/${workload}
cp -f ${level}/${workload}/${workload}.aocx ../bin/${level}/${workload}
cp -f ${level}/${workload}/${workload}.o ../bin/${level}/${workload}

cd $cur_dir

