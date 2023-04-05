# SYRK

## Performance

| Device                 | Frequency | Throughput                   | Logic utilization          | DSP blocks             | RAM blocks           | Matrix and vector Size  | Device compiler           |
| ---------------------- | --------- | ---------------------------- | -------------------------- | ---------------------- | -------------------- | ----------------------- | ------------------------- |
| Intel Arria 10 GX 1150 | 219 MHz   | 197 Mhz (149 % machine peak) | 298,078 / 427,200 ( 70 % ) | 1,027 / 1,518 ( 68 % ) | 963 / 2,713 ( 35 % ) | A (4K, 4K) * B (4K, 4K) | aoc 19.4.0 (on s001-n137) |
