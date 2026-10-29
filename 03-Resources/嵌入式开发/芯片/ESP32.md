---
title: ESP32
created: "2026-10-17T19:37:03+08:00"
modified: "2026-10-17T19:37:03+08:00"
tags:
  - embedded
  - chip
category: SoC
vendor: Espressif
source: 
url: https://www.espressif.com/en/products/socs/esp32
---

# ESP32

> 上级：[[MCU 与芯片 MOC]]

## 概述
- 乐鑫科技（Espressif）的 Wi-Fi + 蓝牙 SoC 系列，广泛用于 IoT。
- 早期 ESP32 采用 Xtensa LX6 双核；新系列转向 RISC-V（C3 / C6 / H2）。

## 关键要点
### 系列
- ESP32：Xtensa LX6 双核，Wi-Fi + 经典蓝牙 + BLE
- ESP32-S2：单核，USB OTG，无蓝牙
- ESP32-S3：双核 LX7，向量指令，面向 AI / 语音
- ESP32-C3 / C6：RISC-V；C6 支持 Wi-Fi 6 与 Thread / Zigbee
- ESP32-H2：RISC-V，Thread / Zigbee，无 Wi-Fi

### 开发
- ESP-IDF：官方框架（基于 FreeRTOS）
- Arduino-ESP32、MicroPython、PlatformIO
- 烧录 / 调试：esptool、内置 USB-JTAG（S3 / C3）、串口下载

### 常见要点
- 启动流程与分区表（partition table）
- OTA 空中升级
- 低功耗：Light-sleep / Deep-sleep 与唤醒源
- 天线与射频布局、PCB 叠层注意

## 相关笔记
- [[MCU 与芯片 MOC]]
- [[RTOS MOC]]
- [[通信协议 MOC]]

## 引用
- 乐鑫官方：<https://www.espressif.com/>
