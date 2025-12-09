# Kitchen

WIP...

Still rough, but at least it's here

Also this guide is not for begineers.

## Traditional way to build kernel

Kernel base: <https://github.com/Saikrishna1504/kernel_xiaomi_mt6785> `bka` branch

thesillyok's susfs 1.5.12 patch base: <https://github.com/TheSillyOk/kernel_ls_patches/blob/master/susfs-1.5.12.patch>

KernelSU scope-minimized hook reference: <https://github.com/backslashxx/KernelSU/issues/5>

Using SukiSU as root implementation.

shallow clone kernel tree

```sh
git clone https://github.com/Saikrishna1504/kernel_xiaomi_mt6785 -b bka --depth 1 kxm
```

then (optional) revert `69_hide_stuff.patch` patch (don't worry, it's short) since we already have susfs especially if you do not use custom rom.

Apply `set-features.sh` to enable some additional kernel features.

Setup SukiSU `susfs-main` (`nongki` if you do not plan to use susfs) branch to kernel root directory. I have mirrored the script (`sukisu-setup.sh` in `ext-scripts` folder) so you do not need to run curl command anymore after cloning this repo.

Apply KernelSU scope-minimized manual hooking using `ksu-hook-min` patchsets from `patches` folder. If any error occurs do maual diff (check `filename.rej` and compare). Do not forget do check original source updates regularly on scope-minimzed hook.

Run `plant-ksu-defconfig.sh` from `kernel-scripts` folder to add KernelSU-related and well known forks entries. If you are trying to run this outside this kernel please compare kernel flags first to prevent duplicate entries.

Adjust KernelSU flags according your needs. In my case i have it pre-configured in `enable-ksu.sh`

Now for susfs. This one is pretty difficult since you have to find backports for latest version or at least newer (you can use official one but official version has stuck and at this moment does not support `susfs-main` branch in SukiSU). There are 2 backport source, [one of sidex15's kernel](https://github.com/sidex15/android_kernel_lge_sm8150) and [JackA1ltman's patch repo](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd). JackA1ltman's backport are usually quicker at updating susfs compared to sidex15's backport, but sidex15's backport seemed has higher quality while taking more time to backport.

NOTE: I do not maintain original susfs patchsets anymore, please use patchsets in `susfs-backports` instead. If you do not use susfs-compatible KernelSU, ~~you can apply KernelSU patch in simonpunk's repository to enable integration since most patchsets i found only patch kernel.~~ If you have SukiSU or forked KernelSU this won't apply anymore as the code changed a lot since then.

Run `plant-susfs-defconfig.sh` to add susfs-related entries. Also run `sussifykernel.sh` enable it.

Run `build.sh` to start building the kernel.

Once done you will get 3 image files (TODO: add `boot.img` support): `Image`, `Image.gz`, `Image.gz-dtb`. Download Anykernel3 from [my AnyKernel3 KernelSU base](https://github.com/F640/AnyKernel3/tree/begonia-ksu-base), place `Image.gz-dtb` in Anykernel3 root folder then zip it. After this flash it to your device.

## shallow clone commit

Sometimes latest kernel changes unstable or does not compile correctly, which makes cloning last good commit required. To do this run these commands:

```sh
git init
git remote add origin https://github.com/Saikrishna1504/kernel_xiaomi_mt6785
git fetch --depth 1 origin <commit sha1>
git checkout FETCH_HEAD
```

If you are making diff you must create two branch to keep track of changes since this kind of clone is branchless (diffing two commits also possible although it is not convenient).

## Enable KPM

For unknown reasons, SukiSU developers does not document anything about adding KPM to kernel other than enabling specific flags and telling kernel patches to backport something vaguely which left us on dark. Thankfully based on others' workflow with this support i've found the way:

1. Enable `CONFIG_KPM` as usual
2. Download either `patch_linux` if you patch using linux or `patch_android` if you patch using android from [here](https://github.com/SukiSU-Ultra/SukiSU_patch/tree/main/kpm). Or compile from [source](https://github.com/SukiSU-Ultra/SukiSU_KernelPatch_patch)
3. Place downloaded either file above to directory one with you kernel. Make sure **"Image" file exists** because their patcher seems hardwired to look for that file.
4. Run it
5. If successful, `oImage` file will appear. That's the patched kernel.
6. Now it's ready to be used on your device if no additional steps required

### Patch failed :(

Usually, these kernel features must be enabled: `CONFIG_KALLSYMS`, `CONFIG_KALLSYMS_ALL`, `CONFIG_KALLSYMS_BASE_RELATIVE`. If any other kernel flags must be enabled to make it successful please tell me.

If still failed then you're out of luck. Report it to developers and hope they won't arbitrarily close your issues.

### Device crashed after running for a while...

I am facing this right now, without KPM version works well. If you have solution please tell me.

## Creating `Image.gz-dtb` from `Image` and `dtb` file

Original Power kernel image format uses `Image.gz-dtb`, but in some cases you want to patch `Image` file which makes you think it isn't possible since the kernel format looks like propietary format, but hey there is a way! This guide is Linux-specific:

1. Prepare your kernel image file and dtb
2. Compress kernel image using gzip command (Example: `gzip -k -6 Image`)
3. After you have it compressed `Image.gz` will appear, now run `cat Image.gz devicetree.dtb > Image.gz-dtb`

Look, now you have created `Image.gz-dtb`. That kernel image format actually is just gzipped kernel image with dtb appended to it.

## KVM

I have enabled KVM in kernel to add virtualization support for apps that utilize this feature. You can check enabled KVM features in `enable-kvm-vfio.sh` script as reference.  Bear in mind this virtualization is pretty limited, it can emulate Linux (testing with Alpine Linux) but can't emulate OS that requires full UEFI (i.e. Windows) with my current kernel (Power Kernel). If you managed to run Windows with it please tell me.

This feature is kinda handy for anyone that wants to run Docker without changing system too much.

Sauce i'm using: https://blog.lyc8503.net/en/post/android-kvm-on-mediatek/

Emulator i'm using: https://github.com/wasdwasd0105/limbo_tensor

## Wireguard

Wireguard also enabled in Power kernel, but sadly it is pretty limited in terms of support as it has local peer issue. To integrate this, run these example commands in your root kernel source:

```
git clone -b master --depth 1 'https://github.com/WireGuard/wireguard-linux-compat' wireguard
./wireguard/kernel-tree-scripts/create-patch.sh | patch -p1
./wireguard/kernel-tree-scripts/jury-rig.sh .
echo "CONFIG_WIREGUARD=y" >> your_kernel_configs
```

As always if you have fix for this issue please tell me.