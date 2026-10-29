---
title: OrangePi RV2 MOC
created: "2026-10-17T20:35:34+08:00"
modified: "2026-10-19T00:49:20+08:00"
tags:
  - moc
  - embedded
  - board
---

# OrangePi RV2 MOC

> 上级：[[嵌入式开发 MOC]] · 路径：`03-Resources/嵌入式开发/开发板/OrangePi RV2/`

## 概览
- OrangePi RV2：SpacemiT K1（又称 Ky X1）8 核 RISC-V 单板机。
- **目标**：从零、只用**行业标准开源栈**，构建可烧录的嵌入式系统并跑起来。
- **原则**：厂商镜像 / 工具**仅参考，不直接使用**；**开发语言 Rust**（用户态；内核模块仍用 C）。
- **主线**：**构建系统镜像 → balenaEtcher 烧录 → 启动**。

## ① 构建系统（重点）
- [[RV2 系统构建]] —— **旗舰**：内核 + rootfs + 引导 → 可烧录镜像
- [[RV2 从零构建嵌入式系统]] —— 理念、开源工具矩阵、总路线图
- [[RV2 根文件系统]] —— Buildroot / Yocto / OpenWrt
- [[RV2 内核与设备树]] —— mainline Linux 与 `k1-orangepi-rv2.dts`
- [[RV2 引导链与固件]] —— FSBL / OpenSBI / U-Boot / FIT
- [[RV2 工具链与编译]] —— 上游工具链 + Rust
- [[RV2 构建环境初始化（rv2-builder）]] —— Yocto/kas 构建容器（Multipass VM）的初始化内容

## ② 烧录
- [[RV2 烧录（balenaEtcher）]] —— balenaEtcher 写卡（备选 dd / mtd-utils / U-Boot `sf`）

## ③ 启动与调试
- [[RV2 首次启动与串口]] —— 3.3V USB-TTL、`ttyS0` 115200
- [[RV2 硬件规格]] —— SoC / 内存 / 存储 / 接口 / 供电

## ④ 应用与外设
- [[RV2 Rust 开发指南]] —— 交叉编译、部署、crate 选型
- [[RV2 Rust 外设编程]] —— GPIO / I2C / SPI / PWM / CAN
- [[RV2 GPIO 与外设]] —— 标准接口、26Pin 与引脚

## 工程（工作区）
- [[RV2 从零构建（工作区）]] —— 可复现构建工作区（Makefile + 脚本 + configs）

## 参考
- [[RV2 常见问题与资源]] —— 已知问题、开源资源、厂商参考

## 待整理
- [ ] 打通「构建 → 烧录 → 启动」一条链路（自建镜像）
- [ ] 用 Buildroot / Yocto 出一版最小 rootfs
- [ ] 验证 K1 上 RVV 的 Rust nightly 构建
- [ ] SPI-NOR 分区表与烧录脚本化
- [ ] 记录实际到手板卡的启动日志与踩坑（同步到 [[嵌入式项目踩坑记录]]）
