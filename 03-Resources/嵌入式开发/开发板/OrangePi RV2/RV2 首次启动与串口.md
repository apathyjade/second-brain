---
title: RV2 首次启动与串口
created: "2026-10-17T20:35:34+08:00"
modified: "2026-10-17T22:53:41+08:00"
tags:
  - embedded
  - board
  - linux
source: http://www.orangepi.org/orangepiwiki/index.php/Orange_Pi_RV2
---

# RV2 首次启动与串口

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 烧录（balenaEtcher）]]、[[RV2 系统构建]]

## 调试串口连接
- 需要一个 **3.3V USB-TTL 模块**（如 CH340 / CH341 / FT2232），用杜邦线连接板子的 DEBUG 3Pin（GND / TXD / RXD）：
  - 模块 GND ↔ 板子 GND，模块 RXD ↔ 板子 TXD，模块 TXD ↔ 板子 RXD（交叉）。
- 串口参数：**115200 8N1**，流控 None。
- 板子侧控制台设备：`ttyS0`，内核 bootargs 为 `console=ttyS0,115200n8`。

## 串口终端软件
```bash
# 找到设备节点
ls /dev/ttyUSB*        # 常见 /dev/ttyUSB0

# Linux / macOS：tio / screen / minicom / putty 均可
sudo tio /dev/ttyUSB0 -b 115200
# 或
sudo screen /dev/ttyUSB0 115200
```
- Windows 平台按官方 wiki「How to use the debug serial port on Windows platform」使用 putty 等。

## 默认登录账号（仅厂商镜像）
> 自建 rootfs 的账号由你自己设定；下表为厂商 Ubuntu 镜像默认值，仅供首次点亮对照。
| 用户名 | 密码 | 说明 |
|--------|------|------|
| `orangepi` | `orangepi` | 默认账户，桌面/终端通常自动登录 |
| `root` | `orangepi` | 超级用户 |

## 首次启动与联网
- 上电后串口会输出 U-Boot 与内核启动日志，随后进入登录界面（`orangepirv2 login:`）。
- 联网方式（任选）：
  - 插网线用 SSH 远程登录；
  - 串口登录后用 `nmtui` / `nmcli` 连接 WiFi；
  - 接 HDMI 显示器与键鼠本地登录。
- 首次接好网络后建议：更新系统、按需 `resize` 扩展文件系统、配置 SSH。

## 快速自检
- LED：板载状态灯（heartbeat）与用户灯；
- 网络：`ip a`、`ping`；
- 串口回环 / 外设：见 [[RV2 GPIO 与外设]]。

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 烧录（balenaEtcher）]]
- [[RV2 GPIO 与外设]]

## 引用
- 官方 wiki（登录 / 串口章节）：<http://www.orangepi.org/orangepiwiki/index.php/Orange_Pi_RV2>
