#!/bin/sh

# enable kernel features

set -e
export DEFCONFIG="$PWD/arch/arm64/configs/begonia_user_defconfig"

# kernelsu and their kids requirements
sed -ri 's/^(CONFIG_KALLSYMS=.*|# CONFIG_KALLSYMS is not set)/CONFIG_KALLSYMS=y/' $DEFCONFIG
sed -ri 's/^(CONFIG_KALLSYMS_ALL=.*|# CONFIG_KALLSYMS_ALL is not set)/CONFIG_KALLSYMS_ALL=y/' $DEFCONFIG

# If you plan to build with vanilla kernelsu (or any kernelsu fork) with manual hook that
# isn't kprobes-tolerant you should to disable these features
sed -ri 's/^(CONFIG_KPROBES=.*|# CONFIG_KPROBES is not set)/CONFIG_KPROBES=y/' $DEFCONFIG
sed -ri 's/^(CONFIG_HAVE_KPROBES=.*|# CONFIG_HAVE_KPROBES is not set)/CONFIG_HAVE_KPROBES=y/' $DEFCONFIG
# sed -ri 's/^(CONFIG_KPROBE_EVENTS=.*|# CONFIG_KPROBE_EVENTS is not set)/CONFIG_KPROBE_EVENTS=y/' $DEFCONFIG
echo "CONFIG_KPROBE_EVENTS=y" >> $DEFCONFIG
# uncomment this if any modules does not like kprobes
# sed -ri 's/^CONFIG_KPROBES=y/# CONFIG_KPROBES is not set/' $DEFCONFIG
# sed -ri 's/^CONFIG_HAVEKPROBES=y/# CONFIG_HAVE_KPROBES is not set/' $DEFCONFIG

# mountify requirements if you need it
sed -ri 's/^(CONFIG_OVERLAY_FS=.*|# CONFIG_OVERLAY_FS is not set)/CONFIG_OVERLAY_FS=y/' $DEFCONFIG
sed -ri 's/^(CONFIG_TMPFS_XATTR=.*|# CONFIG_TMPFS_XATTR is not set)/CONFIG_TMPFS_XATTR=y/' $DEFCONFIG

# maybe helpful one day
sed -ri 's/^(CONFIG_TMPFS_POSIX_ACL=.*|# CONFIG_TMPFS_POSIX_ACL is not set)/CONFIG_TMPFS_POSIX_ACL=y/' $DEFCONFIG

# LKM support
sed -ri 's/^(CONFIG_MODULES=.*|# CONFIG_MODULES is not set)/CONFIG_MODULES=y/' $DEFCONFIG
sed -ri 's/^(CONFIG_MODULE_UNLOAD=.*|# CONFIG_MODULE_UNLOAD is not set)/CONFIG_MODULE_UNLOAD=y/' $DEFCONFIG
sed -ri 's/^(CONFIG_MODVERSIONS=.*|# CONFIG_MODVERSIONS is not set)/CONFIG_MODVERSIONS=y/' $DEFCONFIG

# edit kernel suffix for evade play integrity detection
sed -ri 's/^(CONFIG_LOCALVERSION=.*|# CONFIG_LOCALVERSION is not set)/CONFIG_LOCALVERSION="-PooWeR"/' $DEFCONFIG