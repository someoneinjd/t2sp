source /data/intel_fpga/devcloudLoginToolSetup.sh
tools_setup -t S10OAPI
cd /home/u146242/gemv/s10
aoc -profile -v -report -fpc -fp-relaxed a.cl -o a.aocx -no-interleaving=default -board=pac_s10 -board-package=/glob/development-tools/versions/oneapi/2022.2/oneapi/intelfpgadpcpp/2022.1.0/board/intel_s10sx_pac
cd -
