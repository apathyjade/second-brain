---
title: 固件（Firmware）
created: "2026-10-17T23:21:39+08:00"
modified: "2026-10-17T23:21:39+08:00"
tags:
  - embedded
  - firmware
category: 嵌入式基础
source: https://github.com/riscv-software-src/opensbi
url: https://github.com/riscv-software-src/opensbi
---

# 固件（Firmware）

> 上级：[[嵌入式基础概念 MOC]]

## 概述
- 固化在设备中的软件：从 MCU 的裸机程序，到 SoC 的**低层运行时**（OpenSBI / ATF / UEFI）。
- 与 OS 的边界：固件通常**先于内核**运行，或在内核之下**常驻**，向内核提供特权服务。

## 关键要点

### 两个层面
- **广义**：烧录在硬件里的任何软件（MCU 程序、外设固件、网卡 WiFi/BT 固件）。
- **Linux 启动语境**：内核之前 / 之下的低层软件：
  - RISC-V：**OpenSBI**（SBI 运行时）
  - ARM：**ATF / TF-A**（BL1 / BL2 / BL31 / BL33）
  - x86：UEFI / BIOS

### 引导时 vs 运行时固件（RISC-V OpenSBI）
| 类型 | 说明 | 是否常驻 |
|------|------|----------|
| FW_DYNAMIC | 由前一级传参，移交后退出 | 否 |
| FW_JUMP | 直接跳转到固定地址 | 否 |
| FW_PAYLOAD | 直接内嵌下一级引导 | 否 |
| FW_RUNTIME | 常驻，提供 SBI（关核、复位、IPI） | 是 |

### 设备固件（Linux）
- `/lib/firmware` 下的 blob，由驱动按需 `request_firmware()` 加载（WiFi/BT/GPU 常见）。

### 与 bootloader 的区别
- 固件运行在**更高特权级**（M 态 / EL3），bootloader 通常在操作系统态，见 [[引导加载器（Bootloader）]]。

## 相关笔记
- [[嵌入式基础概念 MOC]]
- [[引导加载器（Bootloader）]]
- [[启动流程（Boot Flow）]]

## 引用
- OpenSBI：<https://github.com/riscv-software-src/opensbi>
- ARM Trusted Firmware：<https://www.trustedfirmware.org/>
