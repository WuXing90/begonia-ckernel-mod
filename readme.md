## What's this?

This repo contains experimental patchsets to build [Power Kernel](https://github.com/Saikrishna1504/kernel_xiaomi_mt6785) with [SukiSU](https://github.com/SukiSU-Ultra/SukiSU-Ultra) and additional kernel features (for niceties) for Xiaomi Redmi Note 8 (Begonia). This setup  may change anytime though, so be prepared with it.

**Dislaimer:** I am not good at coding. **Use it at your own risk!**

## Difference beetween original kernel

Power kernel: Added SukiSU, hide LineageOS patch removed.

## Variants

- SukiSU
- Sukisu with KPM (very unstable atm)

and their debug variants

## Compatibility

Kernels made in this repository only made for global Begonia (**not** Begoniain) users and using official MIUI to keep maintenance simple.

If you need to build the kernel yourself (or adapt it for other kernels), check kitchen folder.

## Obtaining

Go to releases and get your favorite version, latest is preferred, after you got them install it. Alternatively check my CI, it has latest build that i'm currently experimenting.

## To Do

No guarantee will be added, but here's patches i will potentially add in future:
- [Wireguard](https://github.com/WireGuard/wireguard-linux-compat)
- [Baseband Guard](https://github.com/vc-teahouse/Baseband-guard)
- susfs (sidex15's backport)
