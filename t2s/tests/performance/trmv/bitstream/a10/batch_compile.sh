source /data/intel_fpga/devcloudLoginToolSetup.sh
tools_setup -t A10DS
cd /home/u146242/trmv_lab/a10
aoc -v -report -g -profile -fpc -fp-relaxed -no-interleaving=DDR ./a.cl -o ./a.aocx -board=pac_a10
cd -
