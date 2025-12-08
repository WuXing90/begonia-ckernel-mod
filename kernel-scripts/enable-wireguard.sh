#!/bin/sh

set -e

# enable Wireguard (do not forget to add it to your kernel first if your kernel is below 5.6)

export DEFCONFIG="$PWD/arch/arm64/configs/begonia_user_defconfig"

echo "CONFIG_WIREGUARD=y" >> $DEFCONFIG
# echo "CONFIG_WIREGUARD_DEBUG=y" >> $DEFCONFIG
