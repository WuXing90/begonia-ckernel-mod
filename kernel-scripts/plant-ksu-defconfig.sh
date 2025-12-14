#!/bin/bash

set -e
export DEV_DEFCONFIG="$PWD/arch/arm64/configs/begonia_user_defconfig"

# comment means left to config defaults
declare -a add_feature_flags=(
    "CONFIG_KSU"
    "CONFIG_KSU_DEBUG"
    # KSUN and SukiSU specific
    # "CONFIG_KSU_ALLOWLIST_WORKAROUND"
    # KernelSU-Next specific
    "CONFIG_KSU_KPROBES_HOOK"
    # "CONFIG_KSU_LSM_SECURITY_HOOKS"
    # SukiSU specific
    "CONFIG_KPM"

    # hook choice, pick only one (check your kconfig for best method)
    "CONFIG_KSU_NONE_HOOK" # only enable this if you have susfs 2.0.0+
    "KSU_SYSCALL_HOOK" # should not be used in < 5.10 although it has no issues for me
    "CONFIG_KSU_MANUAL_HOOK"

    # "CONFIG_KSU_MANUAL_SU"
    "CONFIG_KSU_MULTI_MANAGER_SUPPORT"
)

# add features logic
for CONFIG in "${add_feature_flags[@]}"
do
   echo "# $CONFIG is not set" >> $DEV_DEFCONFIG
done