#!/bin/bash

source ~/.bashrc && source ~/.profile

SECONDS=0 # builtin bash timer

# Allowed codenames
ALLOWED_CODENAMES=("a52q" "a72q")

# Prompt user for device codename
read -p "Enter device codename: " DEVICE

# Check if the entered codename is in the allowed list
if [[ ! " ${ALLOWED_CODENAMES[@]} " =~ " ${DEVICE} " ]]; then
    echo "Error: Invalid codename. Allowed codenames are: ${ALLOWED_CODENAMES[*]}"
    exit 1
fi

ZIPNAME="${DEVICE}-$(date '+%Y%m%d-%H%M').zip"

# CCache
export LC_ALL=C && export USE_CCACHE=1
ccache -M 20G

export ARCH=arm64
export KBUILD_BUILD_HOST=linux-build
export KBUILD_BUILD_USER="koko"

# Clang
clangbin=../clang/bin/clang
if ! [ -a $clangbin ]; then
wget -O toolchain.tar.gz https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main/clang-r530567.tar.gz
mkdir -p ${PWD}/../clang
tar -xzf toolchain.tar.gz -C ${PWD}/../clang
rm -rf toolchain.tar.gz
fi

make O=out ARCH=arm64 vendor/pixelos-${DEVICE}_defconfig vendor/debugfs.config
PATH="${PWD}/../clang/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC="clang" \
                      AR=llvm-ar \
                      NM=llvm-nm \
                      STRIP=llvm-strip \
                      OBJCOPY=llvm-objcopy \
                      OBJDUMP=llvm-objdump\
                      CROSS_COMPILE=aarch64-linux-gnu-\
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                      LD=ld.lld \
                      CONFIG_NO_ERROR_ON_MISMATCH=y

zimage=out/arch/arm64/boot/Image.gz
if ! [ -a $zimage ];
then
echo  " Failed To Compile Kernel"
exit 1
fi

echo -e "\nKernel compiled successfully! Zipping up...\n"

rm -rf AnyKernel3
git clone --depth=1 https://github.com/koko-07870/AnyKernel3.git -b master AnyKernel3
cp out/arch/arm64/boot/Image.gz AnyKernel3
cd AnyKernel3
zip -r9 "../$ZIPNAME" * -x .git
cd ..
rm -rf AnyKernel3
echo -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"
echo "Zip: $ZIPNAME"
echo
