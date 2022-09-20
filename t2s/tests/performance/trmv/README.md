# TRMV

In this test, we define TRMV as follows:

```
    C := alpha*A*X
```
where `alpha` is a non-zero scalar, `A` is a upper triangular matrix.

The design is the same as GEMV, except that `k` starts from `i`.

## Performance (single precision)

| Device | Frequency | Throughput | Logic utilization | DSP blocks | RAM blocks | Efficiency | Matrix and vector Size | Device compiler |
| ------ | --------- | ---------- | ----------------- | ---------- | ---------- | -----------| ----------- | --------------- |
| Intel Arria 10 GX 1150 | 254 MHz | 29.7 GFLOPS (174 % machine peak) | 96,851 / 427,200 ( 23 % ) | 34 / 1,518 ( 2 % ) | 591 / 2,713 ( 22 % ) | 87 % DDR efficiency | A(32K,32K) * X(32K)  | aoc 19.4.0 (on s001-n137) |  
| Intel Stratix 10 SX 2800 | 267 MHz | 65.1 GFLOPS (184 % machine peak) | 286,247 / 933,120 ( 31 % ) | 66 / 5,760 ( 1 % ) | 1,077 / 11,721 ( 9 % ) | 85 % DDR efficiency | A(64K,64K) * X(64K) | aoc 22.2.0 (on s001-n143) |

Note: 

- The measured throughput exceeds the machine peak since A is an upper triangular matrix, and nearly half computations can be saved.
- TRMV arithmetic intensity is 1/2, so its machine peak throughput is limited by the DDR bandwidth. The Maximum DDR bandwidth is 34133 MB/s for A10 and 76800 MB/s for S10, respectively, which determines the machine peak throughput as 34.1 GFLOPS for A10 and 76.8 GFLOPS for S10 (read half of the input A), respectively.
- The achieved frequency is not sufficiently high on S10, so its throughput is actually bound by computation.
- To reproduce the performance:
```
cd bitstream/a10/host-files
g++ host.cpp -DA10 -g -DLINUX -DALTERA_CL -fPIC -Icommon/inc ./common/src/AOCLUtils/opencl.cpp ./common/src/AOCLUtils/options.cpp $(aocl compile-config) $(aocl link-config) -lelf -o host.out
env BITSTREAM=../a.aocx ./host.out
```
Replace `a10` with `s10` if you target S10.
