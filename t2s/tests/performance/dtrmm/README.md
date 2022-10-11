# TRMM

## Performance

| Device                   | Frequency | Throughput                      | Logic utilization          | DSP blocks             | RAM blocks             | Efficiency      | Matrix and vector Size  | Device compiler           |
| ------------------------ | --------- | ------------------------------- | -------------------------- | ---------------------- | ---------------------- | --------------- | ----------------------- | ------------------------- |
| Intel Arria 10 GX 1150   | 237 MHz   | 199 GFLOPS (164 % machine peak) | 289,970 / 427,200 ( 68 % ) | 1,025 / 1,518 ( 68 % ) | 872 / 2,713 ( 32 % )   | 82 % efficiency | A (2K, 2K) * B (2K, 2K) | aoc 19.2.0 (on s001-n137) |
| Intel Stratix 10 SX 2800 | 282 MHz   | 277 GFLOPS (191 % machine peak) | 634,175 / 933,120 ( 68 % ) | 1,027 / 5,760 ( 18 % ) | 1,092 / 11,721 ( 9 % ) | 96 % efficiency | A (4K, 4K) * B (4K, 4K) | aoc 22.2.0 (on s001-n142) |
