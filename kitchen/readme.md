# Kitchen

WIP...

Still rough, but at least it's here

Also this guide is not for begineers.

Traditional way to build kernel

Kernel base: <https://github.com/Saikrishna1504/kernel_xiaomi_mt6785> `bka` branch

susfs patch base: <https://github.com/TheSillyOk/kernel_ls_patches/blob/master/susfs-1.5.12.patch>

KernelSU scope-minimized hook reference: <https://github.com/backslashxx/KernelSU/issues/5>
Using SukiSU as root implementation.

shallow clone kernel tree

```sh
git clone https://github.com/Saikrishna1504/kernel_xiaomi_mt6785 -b bka --depth 1 kxm
```

then (optional) revert `69_hide_stuff.patch` patch (don't worry, it's short) since we already have susfs.

Apply `set-features.sh` to enable some additional kernel features.

Setup SukiSU `susfs-main` branch to kernel root directory. I have mirrored the script (`sukisu-setup.sh` in `ext-scripts` folder) so you do not need to run curl command anymore.

Apply KernelSU scope-minimized manual hooking using `ksu-hook-min` patchsets from `patches` folder. If any error occurs do maual diff (check `filename.rej` and compare). Do not forget do check upstream updates regularly on scope-minimzed hook.

Run `plant-ksu-defconfig.sh` from `kernel-scripts` folder to add KernelSU-related and well known forks entries. If you are trying to run this outside this kernel please compare kernel flags first to prevent duplicate entries.

Adjust KernelSU flags according your needs. In my case i have it pre-configured in `enable-ksu.sh`

Now for susfs. This one is pretty difficult since you have to find backports for latest version or at least newer (you can use official one but official version has stuck and at this moment does not support `susfs-main` branch in SukiSU).

NOTE: I do not maintain original susfs patchsets anymore, please use patchsets in `susfs-backports` instead. If you do not use susfs-compatible KernelSU, you can apply KernelSU patch in simonpunk's repository to enable integration since most patchsets i found only patch kernel.

Run `plant-susfs-defconfig.sh` to add susfs-related entries. Also run `sussifykernel.sh` enable it.

Run `build.sh` to start building the kernel.

Once done you will get 3 image files (TODO: add `boot.img` support): `Image`, `Image.gz`, `Image.gz-dtb`. Download Anykernel3 from [here](https://github.com/cvnertnc/AnyKernel3/), place `Image.gz-dtb` in Anykernel3 root folder then zip it. After this flash it to your device.