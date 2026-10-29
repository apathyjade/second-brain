---
title: RV2 从零构建嵌入式系统
created: "2026-10-17T22:28:52+08:00"
modified: "2026-10-17T22:53:41+08:00"
tags:
  - embedded
  - board
  - linux
  - build-system
source: https://github.com/riscv/meta-riscv/blob/master/docs/orangepi-rv2-mainline.md
url: https://github.com/openwrt/openwrt
---

# RV2 从零构建嵌入式系统

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 引导链与固件]]、[[RV2 内核与设备树]]、[[RV2 根文件系统]]、[[RV2 Rust 开发指南]]

> 本文是**理念与总纲**；落地实操（构建可烧录镜像）见 [[RV2 系统构建]]。

## 理念与原则
- **只用行业标准的开源组件**：上游/社区优先（Linux mainline、OpenSBI、U-Boot、Buildroot、Yocto、OpenWrt、rustup/cargo）。
- **厂商物仅作参考**：Orange Pi / SpacemiT 的镜像、构建脚本（orangepi-build）、WiringOP、Bianbu 等**不直接使用**，只用于硬件对照与问题复现。
- **从零自建**：裸板 → 固件 → 内核 → rootfs → 应用，全链路可复现、可版本化。
- **诚实边界**：K1 的一级引导 `FSBL` 目前仍需取自 SpacemiT 的**开源 U-Boot 树**（GPL），这是唯一"厂商开源但非上游"的环节，已单独标注（见 [[RV2 引导链与固件]]）。

## 开源工具矩阵
| 层次 | 选用（标准开源） | 说明 |
|------|------------------|------|
| 一级/二级引导 | SpacemiT 开源 U-Boot 树（FSBL，GPL） | 唯一厂商开源环节；上游 U-Boot 对 K1 仍 WIP |
| 固件 | **mainline OpenSBI** | K1 支持已合入（`platform/generic/spacemit/k1.c`） |
| 引导 | **mainline U-Boot**（K1 上游 WIP） | 现状用社区 `pyavitz/spacemit-u-boot` 或厂商树 |
| 内核 | **mainline Linux** | K1 已 mainline；RV2 板级 DTS `k1-orangepi-rv2.dts` |
| 根文件系统 | **Buildroot / Yocto(meta-riscv) / OpenWrt** | 三选一，均可自建 |
| 工具链 | **riscv-gnu-toolchain / LLVM / rustup** | 上游；厂商工具链仅参考 |
| 外设 | **libgpiod / i2c-tools / spidev / mtd-utils / can-utils** | 标准内核接口 |
| 应用语言 | **Rust**（cargo / cross） | 见 [[RV2 Rust 开发指南]] |

## 总路线图
| 阶段 | 目标 | 主要工具 | 产出 | 笔记 |
|------|------|----------|------|------|
| 0 | 板卡准备与串口 | 3.3V USB-TTL | 可观察启动日志 | [[RV2 首次启动与串口]] |
| 1 | 固件与引导链 | OpenSBI + U-Boot + FIT | `boot-bundle.itb` 写入 SPI-NOR | [[RV2 引导链与固件]] |
| 2 | 内核与设备树 | mainline Linux | `Image` + `k1-orangepi-rv2.dtb` | [[RV2 内核与设备树]] |
| 3 | 根文件系统 | Buildroot / Yocto / OpenWrt | 最小可启动 rootfs | [[RV2 根文件系统]] |
| 4 | 组装与烧录 | genimage + balenaEtcher | 可烧录 `.img` → SD 卡 | [[RV2 系统构建]]、[[RV2 烧录（balenaEtcher）]] |
| 5 | 应用层 | Rust + cargo / cross | 交叉编译二进制 | [[RV2 Rust 开发指南]] |
| 6 | 外设与驱动 | libgpiod 等 + Rust crate | GPIO / I2C / SPI 可用 | [[RV2 GPIO 与外设]] |

## 工作区与产物约定（建议）
```
rv2/
├── opensbi/             # mainline OpenSBI
├── u-boot/              # U-Boot（上游或社区 K1 树）
├── linux/               # mainline Linux
├── buildroot/ | yocto/  # rootfs 构建
├── app/                 # Rust 应用（cargo workspace）
└── out/                 # Image / dtb / itb / 镜像
```

## 参考边界（仅参考，不直接使用）
- 厂商镜像与工具：Ubuntu 24.04 官方镜像、Orange Pi OS、orangepi-build、WiringOP。
- 厂商文档：官方 wiki、Bianbu 文档、SpacemiT 工具链。
- 用途：硬件行为对照、引脚确认、问题复现。

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 系统构建]]
- [[RV2 引导链与固件]]
- [[RV2 内核与设备树]]
- [[RV2 根文件系统]]
- [[RV2 烧录（balenaEtcher）]]
- [[RV2 Rust 开发指南]]
- [[工具链与构建 MOC]]

## 引用
- meta-riscv RV2 mainline：<https://github.com/riscv/meta-riscv/blob/master/docs/orangepi-rv2-mainline.md>
- SpacemiT 上游进度：<https://github.com/spacemit-com/.github/blob/main/profile/README.md>
- OpenWrt spacemit target：<https://github.com/openwrt/openwrt/commit/5e2be8e9cbce3b161f106d18ed90b8a67043d4da>
