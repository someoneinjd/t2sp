#!/bin/bash

function show_usage {
    echo "Options: (devcloud|local) (KERNEL) (a10|s10) (tiny|large) (hw|emulator)"
    echo "  KERNEL: *gemm"
    echo "  where * is one of s, d, c, and z."
}

# All the kernels we support
level1_kernels=()
level2_kernels=()
level3_kernels=(sgemm dgemm cgemm zgemm)

if [ $0 == $BASH_SOURCE ]; then
   echo "This script should be sourced, not run."
   exit
fi 

# If any error happens below, we return 1 to indicate there is some wrong option.
wrong_options=1

if [ "$1" != "devcloud" -a "$1" != "local" ]; then
    show_usage
    return
else
    location="$1"
fi

workload=""
for k in ${level1_kernels[*]}; do
  if [[ "$k" == "$2" ]]; then
      workload="$2"
      # Usually, the first letter is the prefix. But for some Level 1 kernels, they can have two-lettered prefixes.
      prefixes=${workload:0:1}
      if [ "$workload" == "scasum" -o "$workload" == "dzasum" -o "$workload" == "scnrm2" -o "$workload" == "dznrm2" -o \
           "$workload" == "csrot" -o "$workload" == "zdrot" -o "$workload" == "csscal" -o "$workload" == "zdscal" -o \
           "$workload" == "sdsdot" ]; then
        prefixes=${workload:0:2}
      fi
      level="level1"
      break
  fi
done
for k in ${level2_kernels[*]}; do
  if [[ "$k" == "$2" ]]; then
      workload="$2"
      prefixes=${workload:0:1}
      level="level2"
      break
  fi
done
for k in ${level3_kernels[*]}; do
  if [[ "$k" == "$2" ]]; then
      workload="$2"
      prefixes=${workload:0:1}
      level="level3"
      break
  fi
done
if [ "$workload" == "" ]; then
    show_usage
    return
fi

if [ "$3" != "a10" -a "$3" != "s10" ]; then
    show_usage
    return
else
    target="$3"
fi

if [ "$4" != "tiny" -a "$4" != "large" ]; then
    show_usage
    return
else
    size="$4"
fi

if [ "$5" != "hw" -a "$5" != "emulator" ]; then
    show_usage
    return
else
    platform="$5"
fi

if [ "$platform" == "emulator" ]; then
    if [ "$size" != "tiny" ]; then
        show_usage
        echo "Note: The emulator option is applicable only to tiny size"
        return
    fi
fi

wrong_options=0
