---
title: nRF52
created: "2026-10-17T19:37:03+08:00"
modified: "2026-10-17T19:37:03+08:00"
tags:
  - embedded
  - chip
category: SoC
vendor: Nordic Semiconductor
source: 
url: https://www.nordicsemi.com/Products/nRF52-Series
---

# nRF52

> 上级：[[MCU 与芯片 MOC]]

## 概述
- Nordic Semiconductor 的 ARM Cortex-M4F 低功耗无线 SoC，主打 BLE / 802.15.4。
- 适合可穿戴、传感器、BLE 外设等低功耗场景。

## 关键要点
### 型号
- nRF52810：入门款，BLE
- nRF52832：经典款，BLE / ANT
- nRF52833 / nRF52840：支持 BLE 5、Thread / Zigbee；52840 带 USB、更大 Flash / RAM

### 协议栈与开发
- SoftDevice（S132 / S140）：闭源 BLE 协议栈
- nRF Connect SDK（基于 Zephyr）：新一代开发方式
- nRF5 SDK：上一代（legacy）
- 工具：nRF Connect for Desktop、nrfutil、J-Link（SWD）

### 常见要点
- SoftDevice 与 App 的 Flash / RAM 分区
- 低功耗：System ON / OFF 与外设分时
- DFU 空中升级（Bootloader + 双 Bank）
- 天线匹配与射频调试

## 相关笔记
- [[MCU 与芯片 MOC]]
- [[RTOS MOC]]
- [[通信协议 MOC]]
- [[调试与测试 MOC]]

## 引用
- Nordic 官方：<https://www.nordicsemi.com/>
