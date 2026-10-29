---
title: 芯片分类（MCU、MPU、SoC）
created: "2026-10-19T03:03:58+08:00"
modified: "2026-10-19T03:03:58+08:00"
tags:
  - embedded
  - chip
  - soc
category: 嵌入式基础
source: https://developer.arm.com/documentation/101420/latest/
url: https://developer.arm.com/documentation/101420/latest/
---

# 芯片分类（MCU、MPU、SoC）

> 上级：[[嵌入式基础概念 MOC]]

## 概述
- 这一轴回答的是：**一颗芯片里集成了什么、算力定位在哪、能不能跑 Linux**。
- 嵌入式常见称谓是一条递进链：**CPU 内核 → MCU → MPU/AP → SoC → SBC/核心板**。越靠右集成的越多、越像"一台电脑"。
- 判别关键不是名字，而是三个硬指标：**有没有 MMU**、**内存够不够**、**片上集成了哪些控制器**。

## 关键要点

### 递进链一览

| 称谓 | 全称 | 集成了什么 | 典型运行 | MMU | 例子 |
|------|------|-----------|---------|-----|------|
| CPU 内核 | Central Processing Unit | 取指 / 译码 / 执行 / 中断控制器 | — | 视型号 | Cortex-M4、Cortex-A55、RISC-V U74 |
| **MCU** | Microcontroller Unit | 内核 + **片内 Flash** + SRAM + 外设 | 裸机 / RTOS | 通常无（只有 MPU） | [[STM32]]、[[nRF52]] |
| **MPU / AP** | Microprocessor Unit / Application Processor | 内核 + 内存控制器，DRAM 需外接 | Linux / Android | **有** | Cortex-A 系列芯片 |
| **SoC** | System on Chip | 一整个"系统"：CPU + GPU + NPU + 存储控制器 + PHY + 外设 | Linux / RTOS | 通常有 | SpacemiT K1、RK3588、i.MX8 |
| **SBC** | Single Board Computer | SoC + DRAM + 存储 + 接口做成**一块整板** | Linux | — | 树莓派、[[OrangePi RV2 MOC]] |
| FPGA / ASIC | — | 可编程逻辑 / 定制流片电路 | 硬件逻辑 | — | Artix、定制芯片 |

**一句话**：MCU / MPU / SoC 是**芯片**；SBC 是**板子**。

### 最容易混的五个点

1. **"MPU"是双义词** —— 这是本页最大的坑：
   - **Microprocessor Unit**：芯片类别（相对 MCU）
   - **Memory Protection Unit**：内核里的一个硬件单元（做内存区域权限，**没有地址翻译**）
   - 看到 MPU 先判断语境；MCU 里说的 MPU 几乎都是后者。
2. **MCU 也可以是 SoC** —— 边界是模糊的。[[ESP32]] 名义上是 MCU，内部却集成了双核 + Wi-Fi/BT 射频 + 大量控制器，本质是 SoC；行业只是习惯沿用"MCU"这个词。**分类是营销与历史惯例，不是严格定义。**
3. **MMU 是"能不能跑 Linux"的分水岭** —— 没有 MMU 就没有虚拟内存、没有进程隔离，Linux 跑不起来（只能跑 RTOS 或裸机）。这是 MCU/MPU 划分的**技术根因**，而不是频率高低。
4. **内核架构 ≠ 芯片类别** —— 同一种指令集两边都做：RISC-V 既能做 MCU（如 CH32V），也能做高性能 SoC（如 K1）；ARM 既有 Cortex-M（MCU）也有 Cortex-A（AP）。
5. **厂商命名会骗人** —— SpacemiT **K1** 又名 **Ky "X1"**，是同一颗 SoC 的两个叫法；很多厂商把 SoC 直接叫"处理器"或"MX 系列"。**以数据手册的框图为准，不要以名字为准。**

### 判断"能不能跑 Linux"的清单
- [ ] **有 MMU**（必需）
- [ ] 主存 ≥ 16–64 MB（[[内存映射与地址布局]]）
- [ ] 有定时器 / 中断控制器 / 串口
- [ ] 有可启动的非易失存储（见 [[存储器分类（ROM、Flash、RAM）]]）

四项满足 → 基本可以跑 Linux；不满足 → 归入 MCU 阵营。

### 和 [[启动流程（Boot Flow）]] 的关系
- MCU：复位后直接从片内 Flash 取指 —— 链路短，没有 MMU 参与。
- SoC/AP：复位 → [[BootROM]] → 一级引导（初始化 DDR）→ [[固件（Firmware）]] → [[引导加载器（Bootloader）]] → 内核。
- **DDR 初始化必须由最初那几段完成**，因为那时主存还不可用 —— 这就是"为什么 SoC 需要多级引导而 MCU 不需要"的根因。

### 本 vault 里的对应
- 具体芯片型号 → `芯片/`（[[STM32]]、[[ESP32]]、[[nRF52]]）
- 具体板卡 → [[OrangePi RV2 MOC]]（K1 SoC + 8 GB LPDDR4X，属于 SBC）
- 芯片选型与型号对比 → [[MCU 与芯片 MOC]]

## 相关笔记
- [[嵌入式基础概念 MOC]]
- [[MCU 与芯片 MOC]]
- [[存储器分类（ROM、Flash、RAM）]]
- [[启动流程（Boot Flow）]]
- [[内存映射与地址布局]]
- [[BootROM]]

## 引用
- ARM Cortex-M 系列文档：<https://developer.arm.com/documentation/101420/latest/>
- RISC-V 特权规范（MMU / 特权级）：<https://riscv.org/technical/specifications/>
