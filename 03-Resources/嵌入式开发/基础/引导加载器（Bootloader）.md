---
title: 引导加载器（Bootloader）
created: "2026-10-17T23:21:39+08:00"
modified: "2026-10-17T23:21:39+08:00"
tags:
  - embedded
  - boot
  - bootloader
category: 嵌入式基础
source: https://www.denx.de/wiki/U-Boot
url: https://www.denx.de/wiki/U-Boot
---

# 引导加载器（Bootloader）

> 上级：[[嵌入式基础概念 MOC]]

## 概述
- BootROM（[[BootROM]]）之后、操作系统之前的一段程序：**初始化硬件并把控制权交给内核**。
- 复杂系统通常**多级**：一级（SPL / FSBL）+ 二级（U-Boot / Barebox / GRUB）。

## 关键要点

### 级别与常见名
| 级别 | 常见名 | 运行位置 | 职责 |
|------|--------|----------|------|
| 一级 | SPL、FSBL、MBOOT | 片内 SRAM | 初始化 DDR / 时钟，装载二级 |
| 二级 | U-Boot、Barebox | DRAM | 命令交互、探测设备、加载内核 |

### 典型能力（以 U-Boot 为例）
- 环境变量（`bootargs`/`bootcmd`）、脚本、**FIT 镜像**加载（见 [[FIT 镜像]]）。
- 介质与网络操作：`mmc`、`sf`、`usb`、`tftp`、`fastboot`、`ums`。
- 交互式控制台（串口）与自动启动（`bootdelay`）。

### 与固件的关系
- RISC-V / AArch64 常把**固件层**（OpenSBI / ATF）与 bootloader 分离：固件在更高特权级提供 SBI/PSCI；U-Boot 在操作系统态（RISC-V S 态 / ARM EL1-EL2）。
- 详见 [[固件（Firmware）]]。

### 是否可覆盖
- **可以覆盖**（写在 Flash 的对应分区）——这正是"自建引导链"的目标。
- 可覆盖的前提与救砖路径取决于 [[BootROM]] 的启动顺序，以及 [[存储分区与 MTD]] 中是否有可写分区。

### 常见坑
- 一级/二级**设备树不一致**导致不兼容（如 mainline OpenSBI + vendor U-Boot）。
- 环境变量损坏导致启动失败（需恢复默认 env）。

## 相关笔记
- [[嵌入式基础概念 MOC]]
- [[启动流程（Boot Flow）]]
- [[BootROM]]
- [[固件（Firmware）]]
- [[FIT 镜像]]

## 引用
- U-Boot 文档：<https://docs.u-boot.org/>
- OpenSBI：<https://github.com/riscv-software-src/opensbi>
