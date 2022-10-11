# SYR2K

In this test, we define SYR2K as follows:

```
    C := A * B^T + A^T * B
```
where `A,B` is a general matrix and `C` is a symmetric matrix

| Device | Frequency | Throughput | Logic utilization | DSP blocks | RAM blocks | Efficiency | Matrix and vector Size | Device compiler |
| ------ | --------- | ---------- | ----------------- | ---------- | ---------- | -----------| ----------- | --------------- |
| Intel Arria 10 GX 1150 | 252 MHz | 852 GFLOPS (163 % machine peak) | 177,601 / 427,200 ( 42 % ) | 1,037 / 1,518 ( 68 % ) | 1,139 / 2,713 ( 42 % ) | 82 % efficiency | A(8K,4K) * B(4K,8K)  | aoc 19.4.0 (on s001-n139) |
