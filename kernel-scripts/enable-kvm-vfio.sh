#!/bin/bash

set -e
export DEV_DEFCONFIG="$PWD/arch/arm64/configs/begonia_user_defconfig"

# comment means left to config defaults
declare -a enable_feature_flags=(
    # KVM
    "CONFIG_VIRTUALIZATION"

    # VFIO
    "CONFIG_VFIO"
    "CONFIG_IOMMU_SUPPORT"
)

declare -a add_enable_feature_flags=(
    # KVM
    "CONFIG_KVM"

    # VFIO
    "CONFIG_VFIO_CCW"
    "CONFIG_VFIO_AP"
    "CONFIG_VFIO_PCI"
    "CONFIG_VFIO_MDEV"
    "CONFIG_VFIO_MDEV_DEVICE"
    "CONFIG_S390_CCW_IOMMU"
    "CONFIG_S390_AP_IOMMU"
)

# enable features logic
for CONFIG in "${enable_feature_flags[@]}"
do
   sed -ri "s/^($CONFIG=.*|# $CONFIG is not set)/$CONFIG=y/" $DEV_DEFCONFIG
done

# add and enable features logic
for CONFIG in "${add_enable_feature_flags[@]}"
do
   echo "$CONFIG=y" >> $DEV_DEFCONFIG
done

# ARM virtualization support
sed -ri "s/^(CONFIG_ARM64_VHE=.*|# CONFIG_ARM64_VHE is not set)/CONFIG_ARM64_VHE=1/" $DEV_DEFCONFIG