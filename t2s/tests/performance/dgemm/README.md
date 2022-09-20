# Matrix Multiply

## Performance

| Device                 | Frequency | Throughput | Logic utilization          | DSP blocks             | RAM blocks             | Matrix Size         | Device compiler           |
| ---------------------- | --------- | ---------- | -------------------------- | ---------------------- | ---------------------- | ------------------- | ------------------------- |
| Intel Arria 10 GX 1150 | 221 MHz   | 126 GFLOPS | 319,124 / 427,200 ( 75 % ) | 1,177 / 1,518 ( 78 % ) | 1,618 / 2,713 ( 60 % ) | A(9K,8K) * B(8K,4K) | aoc 19.4.0 (on s001-n137) |


