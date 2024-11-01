#!/bin/bash

# 设置交叉编译工具链路径
TOOLCHAIN=/opt/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu
SOURCEDIR=$(pwd)
BUILDDIR=$(pwd)/build
INSTALLDIR=$(pwd)/install
EXTDIR=/home/cn1767/work/x5hbase4/out/deploy/system/usr

export PATH=$TOOLCHAIN/bin:$PATH

# 设置交叉编译环境变量
export CROSS_COMPILE=aarch64-none-linux-gnu-
export CC=${CROSS_COMPILE}gcc
export CXX=${CROSS_COMPILE}g++
export ARCH=arm64

# 直接设置 CFLAGS 和 LDFLAGS 以包含自定义头文件和库路径
export CFLAGS="-I$EXTDIR/include $CFLAGS"
export LDFLAGS="-L$EXTDIR/lib $LDFLAGS"

# 创建构建和安装目录
mkdir -p $BUILDDIR
mkdir -p $INSTALLDIR

# 进入构建目录
cd $BUILDDIR

# 运行 bootstrap（如果需要）
if [ ! -f $SOURCEDIR/configure ]; then
    (cd $SOURCEDIR && ./bootstrap.sh)
fi

# 配置构建
$SOURCEDIR/configure --host=aarch64-none-linux-gnu \
            --prefix=/usr \
            --disable-qv4l2 \
            --disable-qvidcap \
            --disable-bpf \
            --without-jpeg

# 编译
make -j$(nproc)

# 安装到临时目录
make DESTDIR=$INSTALLDIR install

echo "交叉编译完成。编译结果在 $INSTALLDIR 目录中。"