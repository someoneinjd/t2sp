source /data/intel_fpga/devcloudLoginToolSetup.sh
tools_setup -t A10DS
cd /home/u146242/syr2k_lab/a10_1
aoc -v -report -g -profile -fpc -fp-relaxed ./a.cl -o ./a.aocx -board=pac_a10
cd -
