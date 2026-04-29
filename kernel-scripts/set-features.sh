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

    # general tracing option for kprobes and tracepoint
    "CONFIG_TRACING"
    # If your kernel have problem with kprobes
    # you should disable kprobes and kretprobes
    "CONFIG_KPROBES"
    # "CONFIG_HAVE_KPROBES" # overidding this option and other CONFIG_HAVE_* options is somewhat not a good practice
    # same goes for this one
    # "CONFIG_HAVE_KRETPROBES" # not problematic, reason to not overide this same as other CONFIG_HAVE_*
    # Tracepoint for KernelSU and its forks just in case
    # CONFIG_HAVE_SYSCALL_TRACEPOINTS # reason to not overide this same as other CONFIG_HAVE_*
    "CONFIG_FTRACE"
    "CONFIG_TRACEPOINTS"

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


# increase dmesg buffer size
sed -ri 's/^(CONFIG_LOG_BUF_SHIFT=.*|# CONFIG_LOG_BUF_SHIFT is not set)/CONFIG_LOG_BUF_SHIFT=17/' $DEV_DEFCONFIG
sed -ri 's/^(CONFIG_LOG_BUF_SHIFT=.*|# CONFIG_LOG_BUF_SHIFT is not set)/CONFIG_LOG_BUF_SHIFT=17/' $STOCK_DEFCONFIG
sed -ri 's/^(CONFIG_LOG_CPU_MAX_BUF_SHIFT=.*|# CONFIG_LOG_CPU_MAX_BUF_SHIFT is not set)/CONFIG_LOG_CPU_MAX_BUF_SHIFT=17/' $DEV_DEFCONFIG
sed -ri 's/^(CONFIG_LOG_CPU_MAX_BUF_SHIFT=.*|# CONFIG_LOG_CPU_MAX_BUF_SHIFT is not set)/CONFIG_LOG_CPU_MAX_BUF_SHIFT=17/' $STOCK_DEFCONFIG

# edit kernel suffix for evade play integrity detection (Disabled as kernel version now harcoded through kernel makefile for better evasion)
# sed -ri 's/^(CONFIG_LOCALVERSION=.*|# CONFIG_LOCALVERSION is not set)/CONFIG_LOCALVERSION="-PooWeR"/' $DEV_DEFCONFIG
