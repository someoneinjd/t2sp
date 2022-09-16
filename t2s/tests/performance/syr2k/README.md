# SYR2K

In this test, we define SYR2K as follows:

```
    C := A * B^T + A^T * B
```
where `A,B` is a general matrix and `C` is a symmetric matrix


| Device | Frequency | Throughput | Logic utilization | DSP blocks | RAM blocks | Efficiency | Matrix and vector Size | Device compiler |
| ------ | --------- | ---------- | ----------------- | ---------- | ---------- | -----------| ----------- | --------------- |
| Intel Arria 10 GX 1150 | 253 MHz | 952 GFLOPS (181 % machine peak) | 204,198 / 427,200 ( 48 % ) | 1,037 / 1,518 ( 68 % ) | 1,216 / 2,713 ( 45 % ) | 91 % efficiency | A(4K,4K) * B(4K,4K)  | aoc 19.4.0 (on s001-n139) |
| Intel Stratix 10 SX 2800 | 256 MHz | 2025 GFLOPS (192 % machine peak) | 400,667 / 933,120 ( 43 % ) | 2,061 / 5,760 ( 36 % ) | 2,458 / 11,721 ( 21 % ) | 96 % efficiency | A(8K,8K) * B(8K,8K) | aoc 19.2.0 (on s005-n005) |

Note:
- Assume A is a `I*K` matrix and B is a `K*J` matrix, throughput is calculated as `2*I*J*K/exec_time`. The measured throughput exceeds the machine peak since A is an upper triangular matrix, and nearly half computations can be saved.
- Efficiency is determined by the theoretical maximum throughput achieved by this design, which should double the machine peak.

- To reproduce the performance:
```
cd bitstream/host-files
g++ host.cpp -DA10 -g -DLINUX -DALTERA_CL -fPIC -Icommon/inc ./common/src/AOCLUtils/opencl.cpp ./common/src/AOCLUtils/options.cpp $(aocl compile-config) $(aocl link-config) -lelf -o host.out
env BITSTREAM=../a10/a.aocx ./host.out
```
Replace `a10` with `s10` if you target S10.