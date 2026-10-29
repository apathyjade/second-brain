---
title: STM32
created: "2026-10-17T19:37:03+08:00"
modified: "2026-10-17T19:37:03+08:00"
tags:
  - embedded
  - chip
category: MCU
vendor: STMicroelectronics
source: 
url: https://www.st.com/en/microcontrollers-microprocessors/stm32-32-bit-arm-cortex-mcus.html
---

# STM32

> 上级：[[MCU 与芯片 MOC]]

## 概述
- STMicroelectronics（意法半导体）的 32 位 MCU 家族，基于 ARM Cortex-M 内核，型号覆盖极广、生态成熟。
- 常见内核：Cortex-M0 / M0+ / M3 / M4(F) / M7 / M33。
- 系列首字母含义：F=基础型、L=低功耗、H=高性能、G=主流型、U=超低功耗、W=无线。

## 关键要点
### 主流系列
- F0 / F1：入门，Cortex-M0 / M3
- F4：经典主流，Cortex-M4F，外设丰富
- F7 / H7：高性能，Cortex-M7，适合 DSP / 图形
- L0 / L4：低功耗系列
- G0 / G4：新一代主流，G4 面向电机控制
- WB / WL：内置无线（BLE / Sub-GHz）
- U5：超低功耗；新代部分采用 Cortex-M33

### 开发工具
- STM32CubeMX：图形化配置 + 生成初始化代码
- HAL / LL 库：HAL 易用、LL 轻量更接近寄存器
- 工具链：STM32CubeIDE、Keil MDK、IAR、PlatformIO、arm-none-eabi-gcc
- 烧录 / 调试：ST-Link（SWD）、OpenOCD、STM32CubeProgrammer

### 常见要点
- 时钟树配置（HSE / HSI / PLL）与总线分频
- 启动模式（BOOT0 / BOOT1）与启动流程
- 低功耗模式：Sleep / Stop / Standby
- 中断向量表与 NVIC 优先级分组

## 相关笔记
- [[MCU 与芯片 MOC]]
- [[工具链与构建 MOC]]
- [[调试与测试 MOC]]

## 引用
- ST 官方：<https://www.st.com/>
