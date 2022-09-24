Our BLAS implementation follows the [CBLAS interface](https://www.intel.com/content/www/us/en/develop/documentation/onemkl-developer-reference-c/top/blas-and-sparse-blas-routines/blas-routines/c-interface-conventions-for-blas-routines.html) of MKL.

# Download the CBLAS interface

The CBLAS interface files are included in a free distribution of MKL. Download and install MKL [here](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-download.html).

Set up path to the MKL, for example:

```
export MKLROOT=$HOME/intel/oneapi/mkl/latest  # Modify this according to your installation
```

# Use a BLAS kernel
We hide all FPGA-specific implementation from users. So users can call a BLAS kernel just as if it is a common C function on CPU. 

For convenience, we have pre-synthesized all the kernels for A10 and S10 FPGAs, and put their bitstreams under `t2s/peppers/blas/lib`.

Each kernel has a test example illustrating the usage of the kernel. For example, for sgemm, 

```
cd t2s/peppers/blas/src/level3/gemm
vi test.cpp # See how gemm is called
./test.sh s tiny emulator # Synthesize and run sgemm with tiny input on an emulator. Replace "s" with "d", "c", "z" for the other data types.
./test.sh s large hw # Synthesize and run sgemm with large input on FPGA.
./test.sh s large hw bitstream # Run the pre-synthesized sgemm kernel with large input on FPGA.
```

