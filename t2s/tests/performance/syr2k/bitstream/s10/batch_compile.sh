source /data/intel_fpga/devcloudLoginToolSetup.sh
tools_setup -t S10DS
cd /home/u146242/syr2k_lab/s10
aoc -v -report -g -profile -fpc -fp-relaxed ./a.cl -o ./a.aocx -board=pac_s10_dc
cd -
