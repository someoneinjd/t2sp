#!/bin/bash

function show_usage {
    echo "Usage:"
    echo "  ./install-tool.sh m4|gmp|mpfr|mpc|cmake|gcc|llvm-clang|python-packages|cm|git-lfs|ninja|re2c|oneapi-esimd|oneapi-support"
}

# No matter the script is sourced or directly run, BASH_SOURCE is always this script, and $1 is the
# argument to the script
T2S_PATH="$( cd "$(dirname "$BASH_SOURCE" )" >/dev/null 2>&1 ; pwd -P )" # The path to this script
if [ "$1" != "m4"  -a  "$1" != "gmp" -a  "$1" != "mpfr" -a  "$1" != "mpc" -a  "$1" != "cmake" -a  "$1" != "gcc" -a "$1" != "llvm-clang" -a "$1" != "python-packages" -a "$1" != "cm" -a "$1" != "git-lfs" -a "$1" != "ninja" -a "$1" != "re2c" -a "$1" != "oneapi-esimd" -a "$1" != "oneapi-support" ]; then
    show_usage
    if [ $0 == $BASH_SOURCE ]; then
        # The script is directly run
        exit
    else
        return
    fi
else
    component="$1"
fi

function install_cmake {
    eval major="$1"
    eval minor="$2"
    echo Installing cmake ...
    mkdir -p cmake-$minor && cd cmake-$minor
    wget -c https://cmake.org/files/v$major/cmake-$minor.tar.gz
    tar -zxvf cmake-$minor.tar.gz > /dev/null
    cd cmake-$minor
    mkdir -p build && cd build
    ../configure --prefix=$T2S_PATH/install > /dev/null
    make -j`nproc` > /dev/null
    make install > /dev/null
    cd ..
    cd ..
    cd ..
}

function install_m4 {
    eval version="$1"
    echo Installing m4 ...
    wget -c http://ftp.gnu.org/gnu/m4/m4-$version.tar.xz
    tar xvf m4-$version.tar.xz > /dev/null
    cd m4-$version
    ./configure --prefix=$T2S_PATH/install > /dev/null
    make -j`nproc` > /dev/null
    make install > /dev/null
    cd ..
}

function install_gmp {
    eval version="$1"
    echo Installing gmp ...
    wget -c https://ftp.gnu.org/gnu/gmp/gmp-$version.tar.xz
    tar xvf gmp-$version.tar.xz > /dev/null
    cd gmp-$version
    ./configure --prefix=$T2S_PATH/install > /dev/null
    make -j`nproc` > /dev/null
    make install > /dev/null
    cd ..
}

function install_mpfr {
    eval version="$1"
    echo Installing mpfr ...
    wget -c https://www.mpfr.org/mpfr-current/mpfr-$version.tar.gz
    tar xvzf mpfr-$version.tar.gz > /dev/null
    cd mpfr-$version
    ./configure --prefix=$T2S_PATH/install --with-gmp=$T2S_PATH/install  > /dev/null
    make -j`nproc` > /dev/null
    make install > /dev/null
    cd ..
}

function install_mpc {
    eval version="$1"
    echo Installing mpc ...
    wget -c https://ftp.gnu.org/gnu/mpc/mpc-$version.tar.gz
    tar xvzf mpc-$version.tar.gz > /dev/null
    cd mpc-$version
    ./configure --prefix=$T2S_PATH/install --with-gmp=$T2S_PATH/install  --with-mpfr=$T2S_PATH/install > /dev/null
    make -j`nproc` > /dev/null
    make install > /dev/null
    cd ..
}

function install_gcc {
    eval version="$1"
    echo Installing gcc ...
    wget -c http://www.netgull.com/gcc/releases/gcc-$version/gcc-$version.tar.gz
    tar xvzf gcc-$version.tar.gz > /dev/null
    mkdir -p gcc-$version-build && cd gcc-$version-build
    export LD_LIBRARY_PATH=$T2S_PATH/install/lib:$T2S_PATH/install/lib64:$LD_LIBRARY_PATH
    ../gcc-$version/configure --enable-languages=c,c++ --disable-multilib --disable-libsanitizer  --prefix=$T2S_PATH/install/gcc-$version --with-gmp=$T2S_PATH/install --with-mpfr=$T2S_PATH/install --with-mpc=$T2S_PATH/install > /dev/null
    make -j`nproc` > /dev/null
    make install > /dev/null
    cd ..
}

function install_llvm_clang {
    eval release="$1"
    eval version="$2"
    eval gcc_version="$3"
    echo Installing llvm and clang ...
    git clone -b release_$release https://github.com/llvm-mirror/llvm.git llvm$version
    git clone -b release_$release https://github.com/llvm-mirror/clang.git llvm$version/tools/clang
    cd llvm$version
    mkdir -p build && cd build
    export PATH=$T2S_PATH/install/bin:$PATH
    export LD_LIBRARY_PATH=$T2S_PATH/install/lib:$T2S_PATH/install/lib64:$LD_LIBRARY_PATH
    CXX=$T2S_PATH/install/gcc-$gcc_version/bin/g++ CC=$T2S_PATH/install/gcc-$gcc_version/bin/gcc cmake -DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,$T2S_PATH/install/gcc-$gcc_version/lib64 -L$T2S_PATH/install/gcc-$gcc_version/lib64" \
        -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_ENABLE_ASSERTIONS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$T2S_PATH/install .. > /dev/null
    make -j`nproc` > /dev/null
    make install > /dev/null
    cd ..
    cd ..
}

function install_python-packages {
    pip install numpy
    pip install matplotlib
}

function install_cm_20211028 {
    wget -c https://01.org/sites/default/files/downloads/cmsdk20211028.zip
    unzip -d $T2S_PATH/install cmsdk20211028.zip
}

function install_cm_20200119 {
    wget -c https://github.com/intel/cm-compiler/releases/download/Master/Linux_C_for_Metal_Development_Package_20200119.zip
    unzip Linux_C_for_Metal_Development_Package_20200119.zip

    cd Linux_C_for_Metal_Development_Package_20200119
    chmod +x compiler/bin/cmc

    cd drivers/media_driver/release
    mkdir extract
    dpkg -X intel-media-u18.04-release.deb extract/
    cd -

    cd drivers/IGC
    mkdir extract
    dpkg -X intel-igc.deb extract/
    cd -

    cd ..
    cp -rf Linux_C_for_Metal_Development_Package_20200119 $T2S_PATH/install
}

function install_git_lfs {
    eval version="$1"
    wget -c https://github.com/git-lfs/git-lfs/releases/download/v3.1.4/git-lfs-linux-amd64-v$version.tar.gz
    mkdir git-lfs
    tar -xvf git-lfs-linux-amd64-v$version.tar.gz -C git-lfs > /dev/null
    cd git-lfs
    sed -i "4c prefix=${T2S_PATH}/install" install.sh
    sed -i "22c git-lfs install --local" install.sh
    ./install.sh
    cd ..
}

function install_ninja {
    git clone https://github.com/ninja-build/ninja.git
    cd ninja
    echo "if you have problems in running configure.py,try replacing the first line of configure.py(#!/usr/bin/env python) to #!/usr/bin/env python3"
    ./configure.py --bootstrap
    cd ..
    cp -rf ninja $T2S_PATH/install
}

function install_re2c {
    wget https://github.com/skvadrik/re2c/releases/download/3.0/re2c-3.0.tar.xz
    tar -xvf re2c-3.0.tar.xz
    rm re2c-3.0.tar.xz
    cd re2c-3.0
    autoreconf -i -W all
    ./configure
    make
    make install
    cd ..
    cp -rf re2c-3.0 $T2S_PATH/install
}

function install_oneapi-esmid-extention {
    export DPCPP_HOME=$T2S_PATH/downloads/sycl_workspace
    mkdir $DPCPP_HOME
    cd $DPCPP_HOME
    git clone https://github.com/intel/llvm -b sycl
    python $DPCPP_HOME/llvm/buildbot/configure.py
    cd ..
    cp -rf sycl_workspace/ $T2S_PATH/install/
    export DPCPP_HOME=$T2S_PATH/install/sycl_workspace
    python $DPCPP_HOME/llvm/buildbot/configure.py
    python $DPCPP_HOME/llvm/buildbot/compile.py
    git clone https://github.com/intel/llvm-test-suite.git
    cp -rf llvm-test-suite/ $T2S_PATH/install/

}

function install-oneapi-support {
    wget https://oneapi.team/tattle/oneAPI-samples/-/raw/9d8b94a38f2a98042cf933adfb91ec1da3d5ad51/DirectProgramming/DPC++FPGA/Tutorials/DesignPatterns/pipe_array/src/pipe_array.hpp?inline=false
    wget https://oneapi.team/tattle/oneAPI-samples/-/raw/9d8b94a38f2a98042cf933adfb91ec1da3d5ad51/DirectProgramming/DPC++FPGA/Tutorials/DesignPatterns/pipe_array/src/pipe_array_internal.hpp?inline=false
    mv pipe_array.hpp?inline=false pipe_array.hpp
    mv pipe_array_internal.hpp?inline=false pipe_array_internal.hpp
    mv pipe_array.hpp $T2S_PATH/t2s/src/oneapi-src
    mv pipe_array_internal.hpp $T2S_PATH/t2s/src/oneapi-src
}

# Below we install newer version of gcc and llvm-clang and their dependencies
mkdir -p $T2S_PATH/install $T2S_PATH/install/bin
export PATH=$T2S_PATH/install/bin:$PATH

cd $T2S_PATH
mkdir -p downloads
cd downloads
if [ "$component" == "m4" ]; then
    install_m4         "1.4.18"
fi
if [ "$component" == "gmp" ]; then
    install_gmp        "6.2.1"
fi
if [ "$component" == "mpfr" ]; then
    install_mpfr       "4.1.0"
fi
if [ "$component" == "mpc" ]; then
    install_mpc        "1.2.1"
fi
if [ "$component" == "cmake" ]; then
    install_cmake      "3.15"  "3.15.7"
fi
if [ "$component" == "gcc" ]; then
    install_gcc        "8.4.0"
fi
if [ "$component" == "llvm-clang" ]; then
    install_llvm_clang "90"    "9.0"    "7.5.0"
fi
if [ "$component" == "python-packages" ]; then
    install_python-packages
fi
if [ "$component" == "cm" ]; then
    # install_cm_20211028
    install_cm_20200119
fi
if [ "$component" == "ninja" ]; then
    install_ninja
fi
if [ "$component" == "re2c" ]; then
    install_re2c
fi
if [ "$component" == "git-lfs" ]; then
    install_git_lfs 3.1.4
fi
if [ "$component" == "oneapi-esimd" ]; then
    install_oneapi-esmid-extention
fi
if [ "$component" == "oneapi-support" ]; then
    install-oneapi-support
fi
cd ..

