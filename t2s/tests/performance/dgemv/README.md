# Matrix Vector Multiply

## Performance

| Device                 | Frequency | Throughput  | Logic utilization          | DSP blocks          | RAM blocks           | Matrix and vector Size | Device compiler           |
| ---------------------- | --------- | ----------- | -------------------------- | ------------------- | -------------------- | ---------------------- | ------------------------- |
| Intel Arria 10 GX 1150 | 246 MHz   | 7.26 GFLOPS | 120,364 / 427,200 ( 28 % ) | 130 / 1,518 ( 9 % ) | 673 / 2,713 ( 25 % ) | A(128K, 4K) * X(4K)    | aoc 19.4.0 (on s001-n137) |
