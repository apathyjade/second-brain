---
title: RV2 工具链与编译
created: "2026-10-17T20:35:34+08:00"
modified: "2026-10-17T22:53:41+08:00"
tags:
  - embedded
  - board
  - rust
  - toolchain
source: https://github.com/riscv-collab/riscv-gnu-toolchain
url: https://github.com/orangepi-xunlong/orangepi-build
---

# RV2 工具链与编译

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 从零构建嵌入式系统]]、[[RV2 引导链与固件]]、[[RV2 内核与设备树]]、[[RV2 Rust 开发指南]]

> 原则：仅用**标准开源工具链**；厂商工具链（SpacemiT）与构建脚本（orangepi-build）**仅参考**。

## Rust 工具链（应用层主线）
- `rustup target add riscv64gc-unknown-linux-gnu` + `.cargo/config.toml` 设 `linker`。
- 或 `cargo install cross` 容器化交叉编译（主机免装交叉包）。
- 完整流程见 [[RV2 Rust 开发指南]]，外设见 [[RV2 Rust 外设编程]]。

## C/C++ 交叉工具链（内核 / 固件）
- **riscv-gnu-toolchain**（上游）：提供 `riscv64-linux-gnu-gcc` / `riscv64-unknown-linux-gnu-gcc`。
- 发行版包：`sudo apt install gcc-riscv64-linux-gnu`（Ubuntu/Debian）。
- **LLVM/Clang**：内核 Rust（RISC-V）要求 LLVM；`clang --target=riscv64-linux-gnu`。
- K1 编译选项：`-mcpu=spacemit-x60 -march=rv64gc_zba_zbb_zbc_zbs`（开 RVV 加 `v`，建议 gcc14）。

## 构建固件与内核（上游源）
```bash
export CROSS_COMPILE=riscv64-linux-gnu-
export ARCH=riscv
# OpenSBI（mainline）
make -C opensbi PLATFORM=generic PLATFORM_DEFCONFIG=k1_defconfig
# U-Boot（K1）
make -C u-boot k1_defconfig && make -C u-boot
# Linux（mainline）
make -C linux k1_defconfig && make -C linux -j$(nproc)
```
- 固件链接与 FIT 打包见 [[RV2 引导链与固件]]；内核与 dtb 见 [[RV2 内核与设备树]]。

## 构建 rootfs
- 由 Buildroot / Yocto / OpenWrt 自带 SDK 完成，见 [[RV2 根文件系统]]。

## 厂商工具链（仅参考，不直接使用）
- SpacemiT 工具链：<http://archive.spacemit.com/toolchain/>（`riscv64-unknown-linux-gnu-gcc`）。
- orangepi-build：<https://github.com/orangepi-xunlong/orangepi-build>（厂商 BSP，含 vendor U-Boot/内核/打包，分支 `v2022.10-ky`、`orange-pi-6.6-ky`）。
- 用途：对照厂商行为、复现问题；**不作为交付依赖**。

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 系统构建]]
- [[RV2 从零构建嵌入式系统]]
- [[RV2 引导链与固件]]
- [[RV2 内核与设备树]]
- [[RV2 根文件系统]]
- [[RV2 Rust 开发指南]]
- [[工具链与构建 MOC]]

## 引用
- riscv-gnu-toolchain：<https://github.com/riscv-collab/riscv-gnu-toolchain>
- rustc RISC-V 平台支持：<https://doc.rust-lang.org/stable/rustc/platform-support/riscv64gc-unknown-linux-gnu.html>
- SpacemiT 工具链（参考）：<http://archive.spacemit.com/toolchain/>
