#!/bin/bash

# enable kernel features

set -e
export DEV_DEFCONFIG="$PWD/arch/arm64/configs/begonia_user_defconfig"
export STOCK_DEFCONFIG="$PWD/arch/arm64/configs/stock_defconfig"
export ENABLE_CONFIG_DEBUG_KERNEL="${ENABLE_CONFIG_DEBUG_KERNEL:-false}"

declare -a enable_feature_flags=(
    # KernelPatch like APatch and their kids requirements
    "CONFIG_KALLSYMS" 
    "CONFIG_KALLSYMS_ALL"
    "CONFIG_KALLSYMS_BASE_RELATIVE"
    # If your kernel have problem with kprobes
    # you should disable kprobes and kretprobes
    "CONFIG_KPROBES"
    "CONFIG_HAVE_KPROBES"
    # same goes for this one
    "CONFIG_HAVE_KRETPROBES"
    # mountify requirements if you need it
    "CONFIG_OVERLAY_FS"
    "CONFIG_TMPFS_XATTR"
    # this might be helpful one day
    "CONFIG_TMPFS_POSIX_ACL"
    # lkm support
    "CONFIG_MODULES"
    "CONFIG_MODULE_UNLOAD"
    "CONFIG_MODVERSIONS"
    # ARM virtualization
    "CONFIG_ARM64_VHE"
    # Just a helpful kernel feature for KernelSU and its forks
    "CONFIG_HAVE_SYSCALL_TRACEPOINTS"
)

declare -a add_enable_feature_flags=(
    # If your kernel have problem with kprobes
    # you should disable kprobes and kretprobes
    "CONFIG_KPROBE_EVENTS"
    # same goes for this one
    "CONFIG_KRETPROBES"
)

declare -a disable_feature_flags=(
)

# SukiSU KPM does not work with CONFIG_DEBUG_KERNEL enabled
if [ "$ENABLE_CONFIG_DEBUG_KERNEL" = "false" ]; then
   disable_feature_flags+=('CONFIG_DEBUG_KERNEL')
fi

declare -a add_disable_feature_flags=(
)

# enable features logic
for CONFIG in "${enable_feature_flags[@]}"
do
   sed -ri "s/^($CONFIG=.*|# $CONFIG is not set)/$CONFIG=y/" $DEV_DEFCONFIG
   sed -ri "s/^($CONFIG=.*|# $CONFIG is not set)/$CONFIG=y/" $STOCK_DEFCONFIG
done

# add and enable features logic
for CONFIG in "${add_enable_feature_flags[@]}"
do
   echo "$CONFIG=y" >> $DEV_DEFCONFIG
   echo "$CONFIG=y" >> $STOCK_DEFCONFIG
done

# disable features logic
for CONFIG in "${disable_feature_flags[@]}"
do
   sed -ri "s/^($CONFIG=.*|# $CONFIG is not set)/# $CONFIG is not set/" $DEV_DEFCONFIG
   sed -ri "s/^($CONFIG=.*|# $CONFIG is not set)/# $CONFIG is not set/" $STOCK_DEFCONFIG
done

# add and disable features logic
for CONFIG in "${add_disable_feature_flags[@]}"
do
   echo "# $CONFIG is not set" >> $DEV_DEFCONFIG
   echo "# $CONFIG is not set" >> $STOCK_DEFCONFIG
done

# edit kernel suffix for evade play integrity detection
sed -ri 's/^(CONFIG_LOCALVERSION=.*|# CONFIG_LOCALVERSION is not set)/CONFIG_LOCALVERSION="-PooWeR"/' $DEV_DEFCONFIG
