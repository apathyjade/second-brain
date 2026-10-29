---
title: RV2 系统构建
created: "2026-10-17T22:53:41+08:00"
modified: "2026-10-19T00:49:20+08:00"
tags:
  - embedded
  - board
  - build-system
  - rootfs
source: https://gitlab.com/buildroot.org/buildroot
url: https://github.com/openwrt/openwrt
---

# RV2 系统构建

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 从零构建嵌入式系统]]、[[RV2 根文件系统]]、[[RV2 内核与设备树]]、[[RV2 引导链与固件]]、[[RV2 烧录（balenaEtcher）]]

> **本文是「构建」章节旗舰**：把内核、rootfs、引导组装成**可烧录的系统镜像**。烧录见 [[RV2 烧录（balenaEtcher）]]。

## 目标与产出
- 产出一个**可烧录的镜像**（如 `rv2-sdcard.img`），用 balenaEtcher 写入 TF 卡后可直接启动。
- 自建为主线（Buildroot / Yocto / OpenWrt）；厂商镜像**仅参考**。

## 系统由什么组成
```
可烧录镜像 (.img)
├── 分区1 FAT (引导)
│   ├── Image                 ← 内核（[[RV2 内核与设备树]]）
│   ├── k1-orangepi-rv2.dtb   ← 设备树
│   └── extlinux.conf         ← 引导项 + cmdline
├── 分区2 ext4 (rootfs)       ← [[RV2 根文件系统]]
└── (SPI-NOR) 引导固件         ← FSBL / OpenSBI / U-Boot（[[RV2 引导链与固件]]）
```

## 三条构建路线（选一）
| 路线 | 一条命令产出 | 适合 |
|------|--------------|------|
| **Buildroot** | `make bananapi_f3_defconfig && make` → `output/images/sdcard.img` | 最小系统、快 |
| **Yocto (meta-riscv)** | `bitbake core-image-minimal` → `.wic`（可转 `.img`） | 可维护、可追溯 |
| **OpenWrt** | `make` → 卡镜像 / `sysupgrade.img` | 网络导向 |
- 细节见 [[RV2 根文件系统]]。

## 组装步骤（Buildroot 为例）
1. **取配置**：以 K1 的 `bananapi_f3_defconfig` 为起点，改 DTS / 机型为 RV2。
2. **内核**：Buildroot 用 mainline 内核 + `k1-orangepi-rv2.dts`（见 [[RV2 内核与设备树]]）。
3. **rootfs**：BusyBox / 自定义；需要 Rust 应用时把它编进去（见 [[RV2 Rust 开发指南]]）。
4. **打包镜像**：Buildroot 用 `genimage` 生成含**引导分区 + rootfs 分区**的 `.img`。
   - 分区布局与 `extlinux.conf` 参考工作区 `configs/`。
5. **引导固件**：FSBL / OpenSBI / U-Boot 单独写 SPI-NOR（见 [[RV2 引导链与固件]]）。

## 手动组装（不用构建系统的镜像打包）
- 自己造 `.img`：`genimage`（配置见工作区 `configs/genimage.cfg`）+ `Image` + `dtb` + `rootfs.ext4`。
- FIT 打包（OpenSBI + U-Boot + 内核）见 [[RV2 引导链与固件]] 与工作区 `configs/boot-bundle.its`。

## 与工作区对应
- 工作区：[[RV2 从零构建（工作区）]]（`01-Projects/RV2 从零构建/`）
- `make opensbi uboot linux` → 组件；`make fit` → 引导捆绑；`make sdcard` → 可烧录镜像。

## 构建环境（Yocto 路线）
- 用 `kas` 编排、在 Multipass VM 里构建：容器初始化内容（宿主机参数、VM 依赖、镜像源、kas 双层配置、`.wic` 取回）见 [[RV2 构建环境初始化（rv2-builder）]]。
- 产出可烧录的 `.wic`（+ `.wic.bmap`），流程接 [[RV2 烧录（balenaEtcher）]]。

## 快速验证
- 构建后用 `file` / `fdisk -l` 检查镜像；
- 再按 [[RV2 烧录（balenaEtcher）]] 写卡、按 [[RV2 首次启动与串口]] 看串口日志。

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 从零构建嵌入式系统]]
- [[RV2 根文件系统]]
- [[RV2 内核与设备树]]
- [[RV2 引导链与固件]]
- [[RV2 工具链与编译]]
- [[RV2 烧录（balenaEtcher）]]
- [[RV2 从零构建（工作区）]]
- [[RV2 构建环境初始化（rv2-builder）]]

## 引用
- Buildroot：<https://gitlab.com/buildroot.org/buildroot>
- meta-riscv：<https://git.yoctoproject.org/meta-riscv/>
- OpenWrt spacemit target：<https://github.com/openwrt/openwrt/commit/5e2be8e9cbce3b161f106d18ed90b8a67043d4da>
