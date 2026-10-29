---
title: 嵌入式基础概念 MOC
created: "2026-10-17T23:21:39+08:00"
modified: "2026-10-19T03:03:58+08:00"
tags:
  - moc
  - embedded
---

# 嵌入式基础概念 MOC

> 上级：[[嵌入式开发 MOC]]

## 概览
- 嵌入式系统从"上电"到"应用"的**通用基础概念**：启动、固件、存储、内核、rootfs 与构建工具。
- 面向**芯片无关的原理**；具体板卡/芯片见对应笔记（如 [[OrangePi RV2 MOC]]、[[STM32]]、[[ESP32]]）。

## 核心笔记

### 芯片与计算单元
- [[芯片分类（MCU、MPU、SoC）]] —— MCU / MPU / SoC / SBC 的边界，MMU 是分水岭

### 启动与固件
- [[启动流程（Boot Flow）]] —— 上电到应用的完整链条
- [[BootROM]] —— SoC 固化的第一段引导
- [[引导加载器（Bootloader）]] —— 一级/二级引导、SPL/FSBL、U-Boot
- [[固件（Firmware）]] —— 固件层与运行环境（OpenSBI / ATF / UEFI）
- [[FIT 镜像]] —— 内核 / dtb / 固件的捆绑格式

### 存储与内存
- [[存储器分类（ROM、Flash、RAM）]] —— 易失/非易失、ROM 的三重含义、XIP
- [[存储分区与 MTD]] —— 分区表、NOR/NAND、mtd-utils
- [[内存映射与地址布局]] —— Flash / RAM / 外设地址、链接脚本

### 内核与用户态
- [[内核与 init 流程]] —— 内核启动与用户态初始化
- [[设备树（Device Tree）]] —— DTS / DTB、硬件描述
- [[根文件系统（rootfs）]] —— BusyBox、挂载、只读 + overlay

### 构建
- [[交叉编译与工具链]] —— CROSS_COMPILE、sysroot、ABI / 三元组

## 派生 / 子主题
- 异常与中断：向量表、异常级别（M/S/U）、特权级切换
- 时钟树与电源管理、复位树
- 启动介质与恢复模式（FEL / DFU / MaskROM / USB 下载）
- 安全启动与签名（镜像验签、可信链）
- 引导介质选择（strap / efuse / BOOT 按键）

## 待整理
- [ ] 各概念补典型示意图（时序 / 地址 / 分区）
- [ ] 与 RV2「从零构建」链路对齐（见 [[RV2 从零构建嵌入式系统]]）
- [ ] 补充「烧录与恢复」独立笔记（FEL/DFU/mtd-utils 汇总）
