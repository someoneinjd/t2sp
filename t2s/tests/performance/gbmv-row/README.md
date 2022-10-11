# Baned Matrix Vector Multiply

## Performance (single precision)

| Device | Frequency | Throughput | Logic utilization | DSP blocks | RAM blocks | Efficiency | Matrix and vector Size | Device compiler |
| ------ | --------- | ---------- | ----------------- | ---------- | ---------- | -----------| ----------- | --------------- |
| Intel Arria 10 GX 1150 | 258 MHz | 109 GFLOPS (216 % machine peak) | 135,769 / 427,200 ( 32 % ) | 98 / 1,518 ( 6 % ) | 864 / 2,713 ( 32 % ) | 81 % DDR efficiency | A(64K,16K) * X(16K), Ku, Kl = 1023 | aoc 19.4.0 (on s005-n004) |
| Intel Stratix 10 SX 2800 | 192 MHz | 364 GFLOPS (489 % machine peak) | 376,237 / 933,120 ( 40 % ) | 194 / 5,760 ( 3 % ) | 1,616 / 11,721 ( 14 % ) | 60 % DDR efficiency | A(128K,64K) * X(64K), Ku, Kl = 1023 | aoc 22.2.0 (on s001-n142) |

Note: 
- We convert a banded input matrix into a compressed format, so the throughput is determined by the matrix's sparsity.
- The computation is similar to GEMV. GEMV arithmetic intensity is only 1/2, so its machine peak throughput is limited by the DDR bandwidth. The Maximum DDR bandwidth is 34133 MB/s for A10 and 76800 MB/s for S10, respectively, which determines the machine peak throughput as 17 GFLOPS for A10 and 38 GFLOPS for S10, respectively.
- To reproduce the performance:
```
cd bitstream/a10/host-files
g++ host.cpp -DA10 -g -DLINUX -DALTERA_CL -fPIC -Icommon/inc ./common/src/AOCLUtils/opencl.cpp ./common/src/AOCLUtils/options.cpp $(aocl compile-config) $(aocl link-config) -lelf -o host.out
env BITSTREAM=../a.aocx ./host.out
```
Replace `a10` with `s10` if you target S10.
