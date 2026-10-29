---
title: 嵌入式开发 MOC
created: "2026-10-17T19:31:06+08:00"
modified: "2026-10-17T23:21:39+08:00"
tags:
  - moc
  - embedded
---

# 嵌入式开发 MOC

> 知识分组入口 · 路径：`03-Resources/嵌入式开发/`

## 概览
- 收录嵌入式开发相关知识：从 MCU 裸机、RTOS 到嵌入式 Linux。
- 本笔记为顶层索引，各子主题各自维护一个 MOC，具体笔记归档在同目录下。

## 核心笔记

### 子主题 MOC
- [[嵌入式基础概念 MOC]] —— 启动流程 / BootROM / 引导器 / 固件 / 存储分区 / 设备树 / rootfs / 工具链（通用概念）
- [[MCU 与芯片 MOC]] —— 架构、厂商、选型、启动流程、时钟/电源
- [[RTOS MOC]] —— FreeRTOS / Zephyr / RT-Thread、调度、同步、内存管理
- [[通信协议 MOC]] —— I2C / SPI / UART / CAN / BLE / WiFi / LoRa / MQTT
- [[工具链与构建 MOC]] —— GCC 交叉编译、CMake、Zephyr west、OpenOCD
- [[调试与测试 MOC]] —— JTAG/SWD、GDB、逻辑分析仪、单元测试

### 开发板 / 芯片
- [[STM32]] —— 意法半导体 Cortex-M 系列 MCU
- [[ESP32]] —— 乐鑫 Wi-Fi + BLE SoC
- [[nRF52]] —— Nordic 低功耗 BLE SoC

### 开发板（SBC）
- [[OrangePi RV2 MOC]] —— RISC-V（SpacemiT K1）单板机，面向 Linux 嵌入式开发

### 经验与备忘
- [[嵌入式项目踩坑记录]] —— 时序 / 烧录 / 稳定性问题沉淀
- [[嵌入式采购与供应链备忘]] —— 器件、供应商、替代料

## 派生 / 子主题
- 硬件基础：数字电路、时序、电平与上拉/下拉
- 语言与规范：C / C++、MISRA、内存对齐、位操作
- 嵌入式 Rust：`no_std` / `embedded-hal` / `cargo` / `cross`
- 低功耗设计：休眠模式、唤醒源、功耗测量
- 嵌入式 Linux：设备树、驱动、Buildroot / Yocto

## 待整理
- [x] 沉淀常用开发板 / 芯片笔记（STM32、ESP32、nRF52）
- [x] 建立项目踩坑记录（时序、烧录、稳定性问题）
- [x] 补充采购 / 供应链相关备忘
- [ ] 补充更多芯片笔记（RP2040、ESP32-S3、GD32…）
- [ ] 归档已完结项目的复盘
