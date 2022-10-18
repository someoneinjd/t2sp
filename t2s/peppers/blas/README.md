# Download MKL for the BLAS interface

The BLAS interface files are included in a free distribution of MKL. Download and install MKL [here](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-download.html).

Set up path to the MKL, for example:

```
export MKLROOT=$HOME/intel/oneapi/mkl/latest  # Modify this according to your installation
```

# Download LAPACK for testing

LAPACK includes a testing suite for BLAS, and we want to leverage it for testing T2S BLAS kernels. 

Download LAPACK [here](https://github.com/Reference-LAPACK/lapack). After installlling LAPACK, follow the document [here](https://netlib.org/lapack/lawnspdf/lawn81.pdf) to test BLAS.
 

# Build T2S BLAS

TODO