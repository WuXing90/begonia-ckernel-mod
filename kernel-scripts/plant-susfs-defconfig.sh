#!/bin/bash

set -e
export DEV_DEFCONFIG="$PWD/arch/arm64/configs/begonia_user_defconfig"

# comment means left to config defaults
declare -a add_feature_flags=(
    "CONFIG_KSU_SUSFS"
    # "CONFIG_KSU_SUSFS_SUS_PATH"
    # "CONFIG_KSU_SUSFS_SUS_MOUNT"
    # "CONFIG_KSU_SUSFS_SUS_KSTAT"
    # "CONFIG_KSU_SUSFS_TRY_UMOUNT"
    # "CONFIG_KSU_SUSFS_AUTO_ADD_TRY_UMOUNT_FOR_BIND_MOUNT"
    # "CONFIG_KSU_SUSFS_SPOOF_UNAME"
    # "CONFIG_KSU_SUSFS_ENABLE_LOG"
    # "CONFIG_KSU_SUSFS_SPOOF_CMDLINE_OR_BOOTCONFIG"
    # "CONFIG_KSU_SUSFS_OPEN_REDIRECT"
    # "CONFIG_KSU_SUSFS_SUS_MAP"
    # dropped (1.5.7)
    # "CONFIG_KSU_SUSFS_SUS_OVERLAYFS"
    # dropped (1.5.11)
    # "CONFIG_KSU_SUSFS_HAS_MAGIC_MOUNT"
    # dropped (2.0)
    "CONFIG_KSU_SUSFS_SUS_SU"
    # deprecated (2.0)
    # "CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSU_DEFAULT_MOUNT"
    # "CONFIG_KSU_SUSFS_AUTO_ADD_SUS_BIND_MOUNT"
)

# add features logic
for CONFIG in "${add_feature_flags[@]}"
do
   echo "# $CONFIG is not set" >> $DEV_DEFCONFIG
done