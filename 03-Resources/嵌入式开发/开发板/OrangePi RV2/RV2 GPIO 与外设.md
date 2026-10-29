---
title: RV2 GPIO 与外设
created: "2026-10-17T20:35:34+08:00"
modified: "2026-10-17T22:28:52+08:00"
tags:
  - embedded
  - board
  - rust
  - gpio
source: https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/
url: https://github.com/orangepi-xunlong/WiringOP
---

# RV2 GPIO 与外设

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 从零构建嵌入式系统]]、[[RV2 Rust 外设编程]]、[[RV2 内核与设备树]]

> 原则：用**标准内核接口**（GPIO chardev / I2C / SPI / PWM / SocketCAN）；WiringOP 等厂商工具**仅参考**。

## Rust 方式（应用主线）
- `linux-embedded-hal` + `gpio-cdev` / `i2cdev` / `spidev` / `socketcan`。
- 完整代码示例见 [[RV2 Rust 外设编程]]。

## 标准命令行工具
| 外设 | 标准工具 | Rust crate |
|------|----------|-----------|
| GPIO | `gpiodetect` / `gpioinfo` / `gpioget` / `gpioset`（libgpiod） | `gpio-cdev` |
| I2C | `i2c-tools` → `i2cdetect -y <bus>` / `i2cget` / `i2cset` | `i2cdev` |
| SPI | `spidev_test`（`/dev/spidevX.Y`） | `spidev` |
| UART | `tio` / `screen` / `picocom` | `serialport` |
| PWM | sysfs `/sys/class/pwm/` | sysfs |
| CAN | `can-utils`（`candump` / `cansend`）+ `ip link set canX up` | `socketcan` |
```bash
sudo apt install gpiod libgpiod-dev i2c-tools can-utils
gpioinfo | head
i2cdetect -y 1
```

## 26Pin 扩展接口
- 支持：**GPIO / UART / I2C / SPI / PWM / CAN**。
- 引脚映射以**设备树 pinctrl** 与实际 DTS 为准；将 `gpioinfo` 的 chip/line 与官方 wiki 的 26Pin 表对照确认，勿凭记忆接线。

## 使能外设（设备树）
- 部分 I2C/SPI/UART/CAN 默认关闭：在 DTS / overlay 中设 `status = "okay"` 与 pinctrl 复用（见 [[RV2 内核与设备树]]）。

## 厂商工具（仅参考，不直接使用）
- WiringOP / wiringOP-Python（WiringPi 分支）：<https://github.com/orangepi-xunlong/WiringOP>（`gpio readall` 等）。
- 用途：快速确认引脚复用与电平；**非标准、绑定厂商内核**，不作为交付依赖。

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 从零构建嵌入式系统]]
- [[RV2 Rust 外设编程]]
- [[RV2 内核与设备树]]
- [[调试与测试 MOC]]

## 引用
- libgpiod：<https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/>
- SPI 用户态 API：<https://docs.kernel.org/spi/spidev.html>
- SocketCAN：<https://docs.kernel.org/networking/can.html>
