---
title: RV2 根文件系统
created: "2026-10-17T22:28:52+08:00"
modified: "2026-10-17T22:53:41+08:00"
tags:
  - embedded
  - board
  - rootfs
  - build-system
source: https://github.com/openwrt/openwrt
url: https://git.yoctoproject.org/meta-riscv/
---

# RV2 根文件系统

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 从零构建嵌入式系统]]、[[RV2 内核与设备树]]、[[RV2 工具链与编译]]

## 三条标准路线
| 方案 | 特点 | RV2 现状 |
|------|------|----------|
| **Buildroot** | 轻量、Make + Kconfig、单命令出镜像 | K1 有 `bananapi_f3_defconfig`（可改写为 RV2） |
| **Yocto (meta-riscv)** | 分层、可维护、产物可追溯 | 有 `orangepi-rv2` 机器（`k1-orangepi-rv2.dtb`） |
| **OpenWrt** | 网络/路由导向、包管理 | 上游已有 `spacemit` target（6.18，multi-dtb FIT，支持 RV2） |

## Buildroot（自建最小系统）
- 以 K1 的 `configs/bananapi_f3_defconfig` 为起点，关键项：
  - `BR2_riscv=y`、`BR2_RISCV_64=y`、`BR2_RISCV_ABI_LP64D=y`
  - `BR2_TARGET_OPENSBI=y`（`PLAT=generic`、`PLATFORM_DEFCONFIG=k1_defconfig`）
  - `BR2_TARGET_UBOOT=y`、`BR2_TARGET_UBOOT_BOARD_DEFCONFIG="k1"`、`BR2_TARGET_UBOOT_NEEDS_OPENSBI=y`
  - `BR2_LINUX_KERNEL=y`、`DEFCONFIG="k1"`、DTS 指向 `k1-orangepi-rv2`
```bash
git clone https://gitlab.com/buildroot.org/buildroot.git
cd buildroot
make bananapi_f3_defconfig        # 起点
make menuconfig                   # 机型/DTS 改 RV2；按需选包
make -j$(nproc)                   # 产物 output/images/
```
- 说明：上游 Buildroot 的 K1 defconfig 默认用**厂商内核/OpenSBI/U-Boot**；若要求纯上游，把 `*_CUSTOM_*` 指向 mainline 源（代价是自行保证 K1 驱动完整）。

## Yocto（meta-riscv）
- 机器配置 `conf/machine/orangepi-rv2.conf`：
  - `KERNEL_DEVICETREE = "spacemit/k1-orangepi-rv2.dtb"`
  - U-Boot：`UBOOT_MACHINE = "bananapi-f3_defconfig"`（RV2 上游 U-Boot 未支持，暂借 BPI-F3 配置）
  - `MACHINE_EXTRA_RRECOMMENDS += "kernel-modules linux-firmware-orangepi"`
- 流程：`source oe-init-build-env` → 设 `MACHINE="orangepi-rv2"` → `bitbake core-image-minimal`。

## OpenWrt（上游 spacemit target）
- 上游 OpenWrt 已含 `target/linux/spacemit`（Linux 6.18），生成 **multi-dtb FIT** 镜像，支持 RV2。
```bash
git clone https://github.com/openwrt/openwrt.git
cd openwrt && ./scripts/feeds update -a && ./scripts/feeds install -a
make menuconfig     # Target: SpacemiT K1 / generic / xunlong_orangepi-rv2
make -j$(nproc)
```

## 从零要点
- 交叉工具链由构建系统自带（Buildroot / Yocto 自建 SDK），无需系统级交叉 gcc。
- 内核与 dtb 用 **mainline**（见 [[RV2 内核与设备树]]）。
- 需要 Rust 应用时，用 Buildroot 的 `rust` 包 / Yocto 的 `meta-rust` 把 cargo 项目编进 rootfs（见 [[RV2 Rust 开发指南]]）。
- SD / eMMC / NVMe 镜像的**组装与烧录**见 [[RV2 系统构建]]、[[RV2 烧录（balenaEtcher）]]。

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 从零构建嵌入式系统]]
- [[RV2 内核与设备树]]
- [[RV2 工具链与编译]]

## 引用
- Buildroot K1 defconfig：<https://lists.buildroot.org/pipermail/buildroot/2024-August/760501.html>
- meta-riscv machine：<https://git.yoctoproject.org/meta-riscv/plain/conf/machine/orangepi-rv2.conf>
- OpenWrt spacemit target：<https://github.com/openwrt/openwrt/commit/5e2be8e9cbce3b161f106d18ed90b8a67043d4da>
- OpenWrt-RISC（社区）：<https://github.com/dgshue/OpenWrt-RISC>
