# General Matrix Rank 1 Update

## Performance (single precision)

| Device | Frequency | Throughput | Logic utilization | DSP blocks | RAM blocks | Efficiency | Matrix and vector Size | Device compiler |
| ------ | --------- | ---------- | ----------------- | ---------- | ---------- | -----------| ----------- | --------------- |
| Intel Arria 10 GX 1150 | 259 MHz | 7.6 GFLOPS (82 % machine peak) | 84,235 / 427,200 ( 20 % ) | 18 / 1,518 ( 1 % ) | 563 / 2,713 ( 21 % ) | 89 % DDR efficiency | X(16K), Y(16K) | aoc 19.4.0 (on s001-n137) |  
| Intel Stratix 10 SX 2800 | 343 MHz | 60.2 GFLOPS (94 % machine peak) | 248,582 / 933,120 ( 27 % ) | 32 / 5,760 ( < 1 % ) | 891 / 11,721 ( 8 % ) | 78 % DDR efficiency | X(32K), Y(32K)  | aoc 22.2.0 (on s001-n081) |

Note: 
- To reproduce the performance:
```
cd bitstream/a10/host-files
g++ host.cpp -DA10 -g -DLINUX -DALTERA_CL -fPIC -Icommon/inc ./common/src/AOCLUtils/opencl.cpp ./common/src/AOCLUtils/options.cpp $(aocl compile-config) $(aocl link-config) -lelf -o host.out
env BITSTREAM=../a.aocx ./host.out
```
Replace `a10` with `s10` if you target S10.
