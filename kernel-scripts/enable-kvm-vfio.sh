#!/bin/bash

set -e
export DEV_DEFCONFIG="$PWD/arch/arm64/configs/begonia_user_defconfig"

# comment means left to config defaults
declare -a enable_feature_flags=(
    # General virtualization
    "CONFIG_VIRTUALIZATION"
    "CONFIG_ARM64_VHE"

    # VFIO
    "CONFIG_VFIO"
    "CONFIG_IOMMU_SUPPORT"

    # Might slow down or causing problems with
    # system, but makes KVM support better
    # (whoops, seems to break compile)
    # "CONFIG_TRANSPARENT_HUGEPAGE"
    # "CONFIG_TRANSPARENT_HUGEPAGE_MADVISE"

    # Misc
    # "CONFIG_ARM64_VA_BITS_48"
    "CONFIG_CMA"
    "CONFIG_ARM_GIC_V3"
)

declare -a add_enable_feature_flags=(
    # KVM
    "CONFIG_KVM"
    "CONFIG_KVM_ARM_HOST"
    "CONFIG_KVM_MMIO"
    "CONFIG_HAVE_KVM_IRQCHIP"
    "CONFIG_HAVE_KVM_IRQ_ROUTING"

    # VFIO
    "CONFIG_VFIO_CCW"
    "CONFIG_VFIO_AP"
    "CONFIG_VFIO_PCI"
    "CONFIG_VFIO_MDEV"
    "CONFIG_VFIO_MDEV_DEVICE"
    "CONFIG_S390_CCW_IOMMU"
    "CONFIG_S390_AP_IOMMU"

    # VirtIO
    "CONFIG_VIRTIO"
    "CONFIG_VIRTIO_BALLOON"
    "CONFIG_VHOST_NET"
    "CONFIG_VHOST_CROSS_ENDIAN_LEGACY"

    # potentially AVF-related options which
    # only available on Android 13 and above
    # CONFIG_VSOCKETS
    # CONFIG_VHOST_VSOCK
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