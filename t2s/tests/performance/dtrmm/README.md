# TRMM

## Performance

| Device                 | Frequency | Throughput                      | Logic utilization          | DSP blocks             | RAM blocks           | Efficiency      | Matrix and vector Size          | Device compiler           |
| ---------------------- | --------- | ------------------------------- | -------------------------- | ---------------------- | -------------------- | --------------- | ------------------------------- | ------------------------- |
| Intel Arria 10 GX 1150 | 237 MHz   | 199 GFLOPS (164 % machine peak) | 289,970 / 427,200 ( 68 % ) | 1,025 / 1,518 ( 68 % ) | 872 / 2,713 ( 32 % ) | 82 % efficiency | A (1408, 1408) * B (1408, 1408) | aoc 19.4.0 (on s001-n137) |
