# Matrix Vector Multiply

## Performance (single precision)

| Device | Frequency | Throughput | Logic utilization | DSP blocks | RAM blocks | Efficiency | Matrix Size | Device compiler |
| ------ | --------- | ---------- | ----------------- | ---------- | ---------- | -----------| ----------- | --------------- |
| Intel Arria 10 GX 1150 | 282 MHz | 15.8 GFLOPS | 87,309 / 427,200 ( 20 % ) | 34 / 1,518 ( 2 % ) | 529 / 2,713 ( 19 % ) | 92% DDR efficiency | X(2K) * A(2K,64K) | aoc 19.4.0 (on s001-n137) |  
| Intel Stratix 10 SX 2800 | 302 MHz | 35.8 GFLOPS | 252,094 / 933,120 ( 27 % ) | 66 / 5,760 ( 1 % ) | 893 / 11,721 ( 8 % ) | 93% DDR efficiency | X(2K) * A(2K,128K) | aoc 22.2.0 (on s001-n081) |

Note: when [measuring the performance](../README.md#Performance-metrics),

- Maximum DDR bandwidth is (A10)34133MB/s / (S10)76800MB/s, respectively. GEMV arithmetic intensity is 1/2, so its theorical peak throughput is (A10)17GFlops / (S10)38GFlops.
- The DDR efficiency of an FPGA equals absolute throughput/theoretical peak throughput.
- Currently it needs manual tweaking. To reproduce the performance:
```
cd bitstream/a10/host-files
g++ host.cpp -DA10 -g -DLINUX -DALTERA_CL -fPIC -Icommon/inc ./common/src/AOCLUtils/opencl.cpp ./common/src/AOCLUtils/options.cpp $(aocl compile-config) $(aocl link-config) -lelf -o host.out
env BITSTREAM=../a.aocx ./host.out
```
Replace `a10` to `s10` if you target S10.

## Design

## [Understand the design](../README.md#how-to-understand-a-design)

## [Test the design](../../../../README.md#Performance-tests)
