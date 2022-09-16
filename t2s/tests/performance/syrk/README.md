# SYRK

In this test, we define SYRK as follows:

```
    C := A * A^T
```
where `A` is a general matrix and `C` is a symmetric matrix

The design is the same as [GEMM](../gemm/README.md), except that `j` starts from `i`.


| Device | Frequency | Throughput | Logic utilization | DSP blocks | RAM blocks | Efficiency | Matrix and vector Size | Device compiler |
| ------ | --------- | ---------- | ----------------- | ---------- | ---------- | -----------| ----------- | --------------- |
| Intel Arria 10 GX 1150 | 259 MHz | 1025 GFLOPS (193 % machine peak) | 185,700 / 427,200 ( 43 % ) | 1,027 / 1,518 ( 68 % ) | 987 / 2,713 ( 36 % ) | 96 % efficiency | A(4K,4K) * B(4K,4K)  | aoc 19.4.0 (on s001-n139) |
| Intel Stratix 10 SX 2800 | 264 MHz | 2028 GFLOPS (187 % machine peak) | 342,060 / 933,120 ( 37 % ) | 2,051 / 5,760 ( 36 % ) | 2,061 / 11,721 ( 18 % ) | 94 % efficiency | A(8K,8K) * B(8K,8K) | aoc 19.2.0 (on s005-n005) |

Note:
- Assume A is a `I*K` matrix and B is a `K*J` matrix, throughput is calculated as `I*J*K/exec_time`. The measured throughput exceeds the machine peak since A is an upper triangular matrix, and nearly half computations can be saved.
- Efficiency is determined by the theoretical maximum throughput achieved by this design, which should double the machine peak.

- To reproduce the performance:
```
cd bitstream/host-files
g++ host.cpp -DA10 -g -DLINUX -DALTERA_CL -fPIC -Icommon/inc ./common/src/AOCLUtils/opencl.cpp ./common/src/AOCLUtils/options.cpp $(aocl compile-config) $(aocl link-config) -lelf -o host.out
env BITSTREAM=../a10/a.aocx ./host.out
```
Replace `a10` with `s10` if you target S10.