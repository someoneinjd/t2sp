# BLAS GEMM Performance

| Kernel | Device | Frequency | Throughput | Logic utilization | DSP blocks | RAM blocks | Efficiency | Matrix Size | Device compiler |
| ------ | ------ | --------- | ---------- | ----------------- | ---------- | ---------- | -----------| ----------- | --------------- |
| SGEMM | Intel Arria 10 GX 1150 | 244 MHz | 620 GFLOPS | 207,854 / 427,200 ( 49 % ) | 1,305 / 1,518 ( 86 % ) | 2,075 / 2,713 ( 76 % ) | 97% DSP efficiency | A(10K,16K) * B(16K,8K) | aoc 19.4.0 (on s001-n137) |
| DGEMM | Intel Arria 10 GX 1150 | 221 MHz   | 126 GFLOPS | 319,124 / 427,200 ( 75 % ) | 1,177 / 1,518 ( 78 % ) | 1,618 / 2,713 ( 60 % ) |  TO CALCULATE | A(9K,8K) * B(8K,4K) | aoc 19.4.0 (on s001-n137) |
| CGEMM | Intel Arria 10 GX 1150 | TO FILL DATA | | | | | |
| ZGEMM | Intel Arria 10 GX 1150 | 235 MHZ | 150 GFLOPS | 311,213 / 427,200 ( 73 % ) | 1,303 / 1,518 ( 86 % ) | 1,366 / 2,713 ( 50 % ) |  TO CALCULATE | A(5K, 4K) * B(4K, 4K) | aoc 19.2.0 |
| SGEMM | Intel Stratix 10 SX 2800 | 251 MHz | 1790 GFLOPS | 446,671 / 933,120 ( 48 % ) | 3,605 / 5,760 ( 63 % ) | 4,054 / 11,721 ( 35 % ) | 99% DSP efficiency | A(14K,16K) * B(16K,16K) | aoc 19.2.0 (on s005-n005) |
| DGEMM | Intel Stratix 10 SX 2800 | TO COLLECT DATA | | | | | | |
| CGEMM | Intel Stratix 10 SX 2800 | TO FILL DATA | | | | | |
| ZGEMM | Intel Stratix 10 SX 2800 | 244 MHZ | 187 GFLOPS |  680,632 / 933,120 ( 73 % ) | 1,557 / 5,760 ( 27 % ) | 1,722 / 11,721 ( 15 % ) | TO CALCULATE | A(4K, 6K) * B(6K, 4K) | aoc 19.2.0 |


