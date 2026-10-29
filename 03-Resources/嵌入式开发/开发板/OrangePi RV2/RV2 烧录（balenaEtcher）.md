---
title: RV2 烧录（balenaEtcher）
created: "2026-10-17T22:53:41+08:00"
modified: "2026-10-17T22:53:41+08:00"
tags:
  - embedded
  - board
  - linux
source: https://etcher.balena.io/
url: https://etcher.balena.io/
---

# RV2 烧录（balenaEtcher）

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 系统构建]]、[[RV2 首次启动与串口]]、[[RV2 引导链与固件]]

> 系统镜像由我们自建，见 [[RV2 系统构建]]；本文只讲**怎么写入介质**。首选 **balenaEtcher**。

## 烧录到 TF 卡（balenaEtcher）
1. 准备：≥8GB TF 卡 + 读卡器；镜像文件 `rv2-sdcard.img`（或 `.img.xz`）。
2. 打开 balenaEtcher → **Flash from file** 选镜像。
3. **Select target** 选 TF 卡（勿选内置硬盘，Etcher 会二次确认）。
4. **Flash!** 等待写入与校验通过。
- 下载：<https://etcher.balena.io/>（开源、跨平台）。

## 备选：命令行 dd
```bash
# 假设目标卡为 /dev/sdX（务必确认，勿写错盘）
sudo dd if=rv2-sdcard.img of=/dev/sdX bs=4M conv=fsync status=progress && sync
```

## 其它介质
- **eMMC / NVMe**：TF 卡启动后再板内 `dd`，或用 U-Boot 的 `mmc` / `nvme` 命令写入。
- **SPI-NOR（引导固件）**：标准 MTD 接口 `flash_erase` + `flashcp`，或 U-Boot `sf`（见 [[RV2 引导链与固件]]）；RV2 SPI-NOR 为 **XM25QU128C**。
  - ⚠️ **刷 SD / eMMC 不改动 SPI-NOR**。

## 烧录之后
- 插入 TF 卡 → 上电 → 按 [[RV2 首次启动与串口]] 接串口看启动日志。

## 厂商镜像（仅参考，不直接使用）
- 官方 Ubuntu / Orange Pi OS 镜像同样可用 balenaEtcher 烧录，但**仅用于首次点亮对照**，非交付主线。
- 下载页：<http://www.orangepi.cn/html/hardWare/computerAndMicrocontrollers/service-and-support/Orange-Pi-RV2.html>

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 系统构建]]
- [[RV2 首次启动与串口]]
- [[RV2 引导链与固件]]

## 引用
- balenaEtcher：<https://etcher.balena.io/>
