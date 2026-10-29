---
title: RV2 硬件规格
created: "2026-10-17T20:35:34+08:00"
modified: "2026-10-17T22:53:41+08:00"
tags:
  - embedded
  - board
  - hardware
vendor: Orange Pi
source: http://www.orangepi.org/orangepiwiki/index.php/Orange_Pi_RV2
url: http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/details/Orange-Pi-RV2.html
---

# RV2 硬件规格

> 上级：[[OrangePi RV2 MOC]]

## 概述
- OrangePi RV2 是采用 SpacemiT K1（Ky X1）SoC 的 RISC-V 单板机，官方主打 Ubuntu 24.04。

## 核心规格
| 项目 | 参数 |
|------|------|
| SoC | SpacemiT K1（又称 Ky X1），8 核 RISC-V `rv64imafdcv`（用户态 rv64gc），2 TOPS AI 融合算力，含 GPU / VPU |
| 内存 | LPDDR4X 2GB / 4GB / 8GB（可选） |
| 板载存储 | eMMC 模块插座（16/32/64/128GB 可选）、SPI-NOR 128Mb（默认，256Mb 可选） |
| 扩展存储 | TF 卡（SDIO3.0）、2× M.2 M-Key 插座（PCIe 2.0 2-Lane，支持 NVMe SSD） |
| 网络 | 2× 千兆以太网（PHY：YT8531C-CA）；Wi-Fi 5 + BT 5.0 二合一模块 AP6256（支持 BLE） |
| 显示 | HDMI 2.0 ×1、4-lane MIPI DSI ×1，支持双屏异显，最高 1920×1440@60fps |
| 摄像头 | 2× 4-lane MIPI CSI |
| USB | 1× USB2.0（HOST 或 DEVICE）、3× USB3.0 HOST、1× USB2.0 HOST（4Pin 排针） |
| 音频 | 3.5mm 耳机座（输入/输出）、HDMI 音频输出 |
| 按键 | BOOT ×1、RESET ×1、PWR ON ×1 |
| RTC | 2Pin 备用电池接口（间距 1.25mm） |
| 扩展接口 | 26Pin（GPIO / UART / I2C / SPI / PWM / CAN 等） |
| 调试串口 | 3Pin DEBUG，3.3V 电平 |
| 供电 | Type-C 5V/5A DC IN；2Pin 电源接口（最大 5V 1A 输出，如接风扇） |
| 尺寸 | 89 × 56 × 1.6 mm |
| 支持系统 | Ubuntu 24.04（官方）；另见 OpenWrt / Orange Pi OS（OH）/ Fedora SpacemiT |

## 说明
- SPI-NOR 中烧录引导固件（FSBL / OpenSBI / U-Boot）；TF / eMMC / NVMe 作为系统盘（见 [[RV2 引导链与固件]]）。
- 外设与引脚复用的权威来源是**设备树 pinctrl**（见 [[RV2 内核与设备树]]）；官方 wiki 的「26 Pin Interface Pin Description」仅作对照。

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 系统构建]]
- [[MCU 与芯片 MOC]]

## 引用
- 官方 wiki：<http://www.orangepi.org/orangepiwiki/index.php/Orange_Pi_RV2>
- 产品页：<http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/details/Orange-Pi-RV2.html>
