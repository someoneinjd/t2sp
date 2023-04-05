# Symmetric Matrix Vector Multiply

## Performance (single precision)

| Device | Frequency | Throughput | Logic utilization | DSP blocks | RAM blocks | Efficiency | Matrix and vector Size | Device compiler |
| ------ | --------- | ---------- | ----------------- | ---------- | ---------- | -----------| ----------- | --------------- |
| Intel Arria 10 GX 1150 | 267 MHz | 30.5 GFLOPS (87 % machine peak) | 165,730 / 427,200 ( 39 % ) | 66 / 1,518 ( 4 % ) | 1,169 / 2,713 ( 43 % ) | 89 % DDR efficiency | A(32K,32K) * X(32K)  | aoc 19.4.0 (on s001-n137) |  
| Intel Stratix 10 SX 2800 | 247 MHz | 60.2 GFLOPS (94 % machine peak) | 522,966 / 933,120 ( 56 % ) | 130 / 5,760 ( 2 % ) | 5,891 / 11,721 ( 50 % ) | 78 % DDR efficiency | A(64K,64K) * X(64K) | aoc 22.2.0 (on s001-n081) |

Note: 

- The achieved frequency is not sufficiently high on S10, so its throughput is actually bound by computation
- To reproduce the performance:
```
cd bitstream/a10/host-files
g++ host.cpp -DA10 -g -DLINUX -DALTERA_CL -fPIC -Icommon/inc ./common/src/AOCLUtils/opencl.cpp ./common/src/AOCLUtils/options.cpp $(aocl compile-config) $(aocl link-config) -lelf -o host.out
env BITSTREAM=../a.aocx ./host.out
```
Replace `a10` with `s10` if you target S10.
