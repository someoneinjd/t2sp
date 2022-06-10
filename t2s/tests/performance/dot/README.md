# Matrix Vector Multiply

## Performance (single precision)

| Device | Frequency | Throughput | Logic utilization | DSP blocks | RAM blocks | Efficiency | Matrix and vector Size | Device compiler |
| ------ | --------- | ---------- | ----------------- | ---------- | ---------- | -----------| ----------- | --------------- |
| Intel Arria 10 GX 1150 | 308 MHz | 7.9 GFLOPS (93 % machine peak) | 71,905 / 427,200 ( 17 % ) | 17 / 1,518 ( 1 % ) | 417 / 2,713 ( 15 % ) | 93 % DDR efficiency | X(64M) * Y(64M)  | aoc 19.4.0 (on s005-n001) |  
| Intel Stratix 10 SX 2800 | 290 MHz | 17.8 GFLOPS (93 % machine peak) | 220,388 / 933,120 ( 24 % ) | 33 / 5,760 ( 1 % ) | 678 / 11,721 ( 6 % ) | 93 % DDR efficiency | X(64M) * Y(64M) | aoc 22.2.0 (on s001-n144) |

Note: 

- DOT arithmetic intensity is only 1/4, so its machine peak throughput is limited by the DDR bandwidth. The Maximum DDR bandwidth is 34133 MB/s for A10 and 76800 MB/s for S10, respectively, which determines the machine peak throughput as 8.5 GFLOPS for A10 and 19.2 GFLOPS for S10, respectively.
- To reproduce the performance:
```
cd bitstream/a10/host-files
g++ host.cpp -DA10 -g -DLINUX -DALTERA_CL -fPIC -Icommon/inc ./common/src/AOCLUtils/opencl.cpp ./common/src/AOCLUtils/options.cpp $(aocl compile-config) $(aocl link-config) -lelf -o host.out
env BITSTREAM=../a.aocx ./host.out
```
Replace `a10` with `s10` if you target S10.
