#!/bin/sh

set -e
export DEFCONFIG="$PWD/arch/arm64/configs/begonia_user_defconfig"

echo '# CONFIG_KSU is not set' >> $DEFCONFIG
echo '# CONFIG_KSU_DEBUG is not set' >> $DEFCONFIG

# KSUN and SukiSU specific
echo '# CONFIG_KSU_ALLOWLIST_WORKAROUND is not set' >> $DEFCONFIG

# KernelSU-Next specific
echo '# CONFIG_KSU_KPROBES_HOOK is not set' >> $DEFCONFIG
echo '# CONFIG_KSU_LSM_SECURITY_HOOKS is not set' >> $DEFCONFIG

# SukiSU specific
echo '# CONFIG_KPM is not set' >> $DEFCONFIG
echo '# CONFIG_KSU_MANUAL_HOOK is not set' >> $DEFCONFIG
echo '# CONFIG_KSU_MANUAL_SU is not set' >> $DEFCONFIG
echo '# CONFIG_KSU_MULTI_MANAGER_SUPPORT is not set' >> $DEFCONFIG