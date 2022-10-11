# Matrix Multiply

## Performance (single precision complex number)

| Device | Frequency | Throughput | Logic utilization | DSP blocks | RAM blocks | Efficiency | Matrix Size | Device compiler |
| ------ | --------- | ---------- | ----------------- | ---------- | ---------- | -----------| ----------- | --------------- |
| Intel Arria 10 GX 1150 | 230 MHz | 582 GFLOPS | 175,628 / 427,200 ( 41 % ) | 1,305 / 1,518 ( 86 % ) | 2,010 / 2,713 ( 74 % ) | 97% DSP efficiency | A(10K,8K) * B(8K,4K) | aoc 19.4.0 (on s001-n137) |
