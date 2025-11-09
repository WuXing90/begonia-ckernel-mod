WIP. not sure i can continue this...

## What's this?

This repo contains experimental patchsets to build [Power Kernel](https://github.com/Saikrishna1504/kernel_xiaomi_mt6785) with [SukiSU](https://github.com/SukiSU-Ultra/SukiSU-Ultra), susfs (backported), and additional kernel features (for niceties) for Xiaomi Redmi Note 8 (Begonia). This setup  may change anytime though, so be perpared with it.

**Dislaimer:** I am not good at coding. **Use it at your own risk!** Also at the moment i do not test the kernel since my phone bricked after experimenting with my changes (maybe due to module problems).


## Variants

- SukiSU and susfs
- Sukisu with KPM and susfs

and their debug variants (SukiSU only)

Maybe in future i might will enable limited KVM support due to [this](https://blog.lyc8503.net/en/post/android-kvm-on-mediatek/), but who knows...

## Obtaining

Go to releases and get your favorite version. Latest is preferred. After you got them install it.

## Compatibility

Kernels made in this repository only made for global Begonia (**not** Begoniain) users and using official MIUI to keep maintenance simple.

If you need to build the kernel yourself (or adapt it for other kernels) go to kitchen folder.

## Closing

Thanks to Android modding enthusiasts to make this all possible especially backported susfs!
