---
title: 启动流程（Boot Flow）
created: "2026-10-17T23:21:39+08:00"
modified: "2026-10-17T23:21:39+08:00"
tags:
  - embedded
  - boot
category: 嵌入式基础
source: 
url: 
---

# 启动流程（Boot Flow）

> 上级：[[嵌入式基础概念 MOC]]

## 概述
- 嵌入式系统"从上电到应用"的过程，分两大类：**MCU 裸机 / RTOS**（复位后直接执行 Flash）与 **SoC 跑 Linux**（多级引导）。
- 共性：**复位后 CPU 从固定地址取第一条指令**；该地址指向什么存储、从哪个介质启动，由硬件（strap / efuse / BOOT 键）决定。

## 关键要点

### SoC + Linux 的典型链条
```
上电复位
  → BootROM（SoC 固化）       找并加载第一段固件
  → 一级引导（FSBL / SPL）     初始化 DDR、时钟，装载下一级
  → 固件（OpenSBI / ATF）      提供运行时服务（SBI / PSCI）
  → 二级引导（U-Boot）         探测设备、加载内核
  → 内核（Linux）              初始化驱动、挂载 rootfs
  → init / systemd             拉起用户态
```

### MCU 的典型链条
```
上电复位
  → 从 Flash 取中断向量表（MSP + Reset_Handler）
  → 启动文件（.data 搬移、.bss 清零）
  → main()
（变体：BootROM → bootloader → 应用；启动模式由 BOOT0/BOOT1 等 strap 决定）
```

### 三个关键变量
- **启动介质**：片内 Flash、SPI-NOR、eMMC、SD、USB。
- **选择机制**：strap 引脚 / efuse / BOOT 按键 / 引导变量。
- **各段职责**：越靠前越贴近硬件、职责越少、越不易变（BootROM 完全不可变）。

### 设计含义
- 想"自建系统"，通常从**可覆盖的那几段**入手（一级/二级引导、内核、rootfs），而 BootROM 固定不变。
- 是否能在某介质上自启动，取决于 BootROM 的**启动顺序**——详见 [[BootROM]]。

## 相关笔记
- [[嵌入式基础概念 MOC]]
- [[BootROM]]
- [[引导加载器（Bootloader）]]
- [[固件（Firmware）]]
- [[内核与 init 流程]]

## 引用
- 
