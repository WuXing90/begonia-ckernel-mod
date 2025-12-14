#!/bin/sh

set -e

# enable sukisu (manual hook, with kprobes support)

export DEFCONFIG="$PWD/arch/arm64/configs/begonia_user_defconfig"

sed -ri 's/^(CONFIG_KSU=.*|# CONFIG_KSU is not set)/CONFIG_KSU=y/' $DEFCONFIG

# not part of vanilla kernelsu (sukisu in this case)
sed -ri 's/^(CONFIG_KSU_KPROBES_HOOK=.*|# CONFIG_KSU_KPROBES_HOOK is not set)/# CONFIG_KSU_KPROBES_HOOK is not set/' $DEFCONFIG
sed -ri 's/^(CONFIG_KSU_MULTI_MANAGER_SUPPORT=.*|# CONFIG_KSU_MULTI_MANAGER_SUPPORT is not set)/CONFIG_KSU_MULTI_MANAGER_SUPPORT=y/' $DEFCONFIG

# only for sukisu
if [ "$1" == 'sukisusfs200' ]; then
   sed -ri 's/^(CONFIG_KSU_NONE_HOOK=.*|# CONFIG_KSU_NONE_HOOK is not set)/CONFIG_KSU_NONE_HOOK=y/' $DEFCONFIG
else
   sed -ri 's/^(CONFIG_KSU_MANUAL_HOOK=.*|# CONFIG_KSU_MANUAL_HOOK is not set)/CONFIG_KSU_MANUAL_HOOK=y/' $DEFCONFIG
fi