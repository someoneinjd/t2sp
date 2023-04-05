source /data/intel_fpga/devcloudLoginToolSetup.sh
tools_setup -t A10DS 1.2.1
cd /home/u146718/syrk_lab/a10
aoc -v -report -g -profile -fpc -fp-relaxed ./a.cl -o ./a.aocx -board=pac_a10
cd -
