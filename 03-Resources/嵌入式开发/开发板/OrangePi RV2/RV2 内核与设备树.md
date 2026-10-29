---
title: RV2 内核与设备树
created: "2026-10-17T20:35:34+08:00"
modified: "2026-10-17T22:53:41+08:00"
tags:
  - embedded
  - board
  - kernel
source: https://github.com/torvalds/linux
url: https://github.com/spacemit-com/linux
---

# RV2 内核与设备树

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 从零构建嵌入式系统]]、[[RV2 引导链与固件]]、[[RV2 GPIO 与外设]]

> 原则：以 **mainline Linux** 为准；厂商内核（Bianbu / Orange Pi ky）仅参考。

## 内核来源
- **mainline Linux**：K1 已 mainline（SpacemiT 上游进度标注 "Mainline support"）。
- **mainline 板级 DTS**：`arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts`（初始版为**最小**：串口控制台 + 心跳 LED）。
- 厂商内核（仅参考）：`spacemit-com/linux`、Bianbu `linux-6.6`、Orange Pi `orange-pi-6.6-ky`。
- 命名对照：mainline `k1-orangepi-rv2.dts`（连字符）↔ 厂商 `k1-x_orangepi-rv2.dts`（下划线）。

## 设备树（mainline 优先）
- `k1-orangepi-rv2.dts`：mainline 初始版仅使能串口与心跳 LED（LED 为 `GPIO_ACTIVE_LOW`）。
- 完整外设（双 GbE/EMAC、SD、USB、PCIe、PMIC 等）尚未全部进 mainline 板级 DTS；需要时以 **mainline-master 的 `k1.dtsi` / `k1-pinctrl.dtsi` 系列**为基础扩展（参考 OpenWrt spacemit target 的做法：以 mainline-master DTS 回移补齐板级）。
- 关键节点参考（厂商 DTS，仅参考）：`chosen` 控制台 `console=ttyS0,115200n8`、`stdout-path="serial0:115200n8"`；8 核 CPU（cluster0/cluster1，标 `cpu-ai`，ISA `rv64imafdcbv_...`）；PMIC `spm8821@41`（I2C8）；WiFi `brcmfmac`(AP6256) 电源时序（`regon-gpios` GPIO 116）；`sys-led`(heartbeat)。

## 构建内核
```bash
export ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu-
make k1_defconfig        # 或用 defconfig 片段自建最小配置
make -j$(nproc) Image dtbs
```
- 产物：`Image` 与 `k1-orangepi-rv2.dtb`，交给 [[RV2 引导链与固件]] 打包进 FIT（`boot-bundle.itb`）。

## Rust for Linux（内核模块）
- 内核 Rust 在 RISC-V 上**仅支持 `riscv64` + LLVM/Clang**（不支持 GCC），需 `bindgen` / `libclang`。
- 上游 RISC-V 内核 Rust 支持约 **6.10** 合入；6.6 LTS 的 Rust 编译器版本被**固定**。
- 结论：**不在 RV2 上写 Rust 内核模块**；Rust 走用户态（见 [[RV2 Rust 开发指南]]）。

## mainline / 替代发行版进展
- OpenWrt：上游 `spacemit` target（Linux 6.18，multi-dtb FIT）已支持 RV2。
- Yocto：meta-riscv `orangepi-rv2`（内核 DTS `spacemit/k1-orangepi-rv2.dtb`）。
- 已知问题（SD clock、WiFi 时序、以太网抖动等）见 [[RV2 常见问题与资源]]。

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 系统构建]]
- [[RV2 从零构建嵌入式系统]]
- [[RV2 引导链与固件]]
- [[RV2 根文件系统]]
- [[RV2 常见问题与资源]]

## 引用
- mainline K1 dtsi：<https://github.com/torvalds/linux/blob/master/arch/riscv/boot/dts/spacemit/k1.dtsi>
- SpacemiT RV2 DTS commit：<https://github.com/spacemit-com/linux/commit/bab8dea259100a99e047fd11a48940b229d30031>
- Rust for Linux 架构支持：<https://docs.kernel.org/rust/arch-support.html>
- SpacemiT 上游进度：<https://github.com/spacemit-com/.github/blob/main/profile/README.md>
