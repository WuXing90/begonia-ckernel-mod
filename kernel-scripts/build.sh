#!/bin/bash
# build script based on https://github.com/Nova-Kernels/kernel_xiaomi_mt6785
# put this in kernel's root repo

set -euo pipefail

SECONDS=0
KERNEL_PATH=$PWD # adjust this if you need it
AK3_DIR="$KERNEL_PATH/Anykernel"
DEFCONFIG="${2:-begonia_user_defconfig}"
BUILD_USER=$(whoami)
BUILD_HOST=$(cat /etc/hostname)
FAKE_BUILD_TIME="${KERNEL_BUILD_TIME:-$(date)}"
TOOLCHAIN_DIR="$KERNEL_PATH/toolchain"
OUT_DIR="$KERNEL_PATH/out"

export KBUILD_BUILD_USER="$BUILD_USER"
export KBUILD_BUILD_HOST="$BUILD_HOST"
export KBUILD_BUILD_TIMESTAMP="$FAKE_BUILD_TIME"
export ARCH=arm64
export PATH="$TOOLCHAIN_DIR/bin:$PATH"
export USE_HOST_LEX=yes

install_tools() {
    mkdir -p "$TOOLCHAIN_DIR" && cd "$TOOLCHAIN_DIR"
    curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman"
    chmod +x antman && ./antman -S
    cd "$KERNEL_PATH"
}

regen_defconfig() {
    make O="$OUT_DIR" ARCH=arm64 "$DEFCONFIG" savedefconfig
    cp "$OUT_DIR/defconfig" "arch/arm64/configs/$DEFCONFIG"
}

build_kernel() {
    [[ ! -d "$TOOLCHAIN_DIR/bin" ]] && install_tools
    echo -e "------------------------"
    echo -e "environment info:"
    echo -e "Build user: $KBUILD_BUILD_USER"
    echo -e "Build host: $KBUILD_BUILD_HOST"
    echo -e "Build date (embed to kernel): $KBUILD_BUILD_TIMESTAMP"
    echo -e "------------------------"
    mkdir -p "$OUT_DIR"
    make O="$OUT_DIR" CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 "$DEFCONFIG"
    exec 2> >(tee -a "$OUT_DIR/error.log" >&2)
    make -j"$(nproc)" \
        O="$OUT_DIR" \
        CC=clang LLVM=1 LLVM_IAS=1 \
        AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy \
        OBJDUMP=llvm-objdump STRIP=llvm-strip \
        LD=ld.lld \
        CROSS_COMPILE=aarch64-linux-gnu- \
        CROSS_COMPILE_ARM32=arm-linux-gnueabi-

    echo -e "\nBuild complete, you can find the image file in out/arch/arm64/boot folder"
    echo -e "Usually there are 3 image files, Image, Image.gz, and Image.gz-dtb. Image.gz-dtb is recommended"
    echo -e "to package and flash with Anykernel3"
    echo -e "\nBuild time: $((SECONDS / 60)) min $((SECONDS % 60)) sec"
}

case "${1:-}" in
    -r|--regen) regen_defconfig ;;
    -b|--build) build_kernel ;;
    *) echo -e "\nUsage: $0 [option] [defconfig]\n  -b, --build    Build kernel\n  -r, --regen    Regenerate defconfig\n"; exit 1 ;;
esac