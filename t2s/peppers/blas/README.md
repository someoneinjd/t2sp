# Download MKL for the BLAS interface

The BLAS interface files are included in a free distribution of MKL. Download and install MKL [here](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-download.html).

Modify the `MKLROOT` variable in `YOUR_T2S_PATH/setenv.sh` accordingly.

# Download LAPACK for testing

LAPACK includes a BLAS implementation and a testing suite for BLAS. We want to leverage the suite for testing T2S BLAS kernels. 

Download LAPACK [here](https://github.com/Reference-LAPACK/lapack). After installlling LAPACK, follow the document [here](https://netlib.org/lapack/lawnspdf/lawn81.pdf) to test LAPACK's internal BLAS implementation.

Modify the `LAPACKROOT` variable in your `YOUR_T2S_PATH/setenv.sh` accordingly.

# Build T2S BLAS

+ Build T2S per instructions `YOUR_T2S_PATH/README.md`.
+ Set up environment

```
    cd YOUR_T2S_PATH
    source setenv.sh (devcloud|local) fpga
```
+ Build kernels one by one, e.g.

```
    cd t2s/peppers/blas/build
    ./synthesize.sh (devcloud|local) sgemm (a10|s10) (tiny|large) (hw|emulator)
```

+ Compile the kernels' interface files into a library `kernels.so`

TODO: add a command here

TODO: copy t2s/tests/performance/devcloud-jobs.sh and devcloud-job.sh here, and let it launch synthesis on DevCloud.

# Test T2S BLAS

Follow the instructions of the LAPACK [document](https://netlib.org/lapack/lawnspdf/lawn81.pdf) to add T2S BLAS into LAPACK's BLAS test suite.