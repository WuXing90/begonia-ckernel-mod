#!/bin/sh

set -e

# enable sukisu (manual hook, with kprobes support)

export DEFCONFIG="$PWD/arch/arm64/configs/begonia_user_defconfig"

sed -ri 's/^(CONFIG_KSU=.*|# CONFIG_KSU is not set)/CONFIG_KSU=y/' $DEFCONFIG

# not part of vanilla kernelsu (sukisu in this case)
sed -ri 's/^(CONFIG_KSU_KPROBES_HOOK=.*|# CONFIG_KSU_KPROBES_HOOK is not set)/# CONFIG_KSU_KPROBES_HOOK is not set/' $DEFCONFIG
sed -ri 's/^(CONFIG_KSU_MANUAL_HOOK=.*|# CONFIG_KSU_MANUAL_HOOK is not set)/CONFIG_KSU_MANUAL_HOOK=y/' $DEFCONFIG