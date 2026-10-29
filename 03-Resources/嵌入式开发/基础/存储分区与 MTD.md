---
title: 存储分区与 MTD
created: "2026-10-17T23:21:39+08:00"
modified: "2026-10-17T23:21:39+08:00"
tags:
  - embedded
  - storage
category: 嵌入式基础
source: https://git.infraroot.at/mtd-utils/
url: https://git.infraroot.at/mtd-utils/
---

# 存储分区与 MTD

> 上级：[[嵌入式基础概念 MOC]]

## 概述
- 非易失存储（SPI-NOR、SPI-NAND、eMMC、SD）通常划分为**多个分区**，分别放引导固件、内核、rootfs、环境变量等。
- Linux 里 **NOR / NAND 走 MTD 子系统**（`/dev/mtd*`），**eMMC / SD 走块设备层**（`/dev/mmcblk*`）。

## 关键要点

### 分区表
- 格式因平台而异：GPT / MBR（块设备）、设备树 `partitions` 节点（MTD）、专用分区表（如 U-Boot env）。
- 板内查看：
  - `cat /proc/mtd`（MTD 分区）
  - `lsblk` / `fdisk -l`（块设备）

### 刷写工具
| 目标 | 工具 |
|------|------|
| MTD 分区 | `flash_erase` + `flashcp`（mtd-utils） |
| 内存 ↔ MTD | `mtd_debug`、`dd` |
| U-Boot 内 | `sf probe` / `sf update`（SPI-NOR）、`mmc write` |
| 块设备 | `dd`、balenaEtcher（见 [[RV2 烧录（balenaEtcher）]]） |

### NOR 与 NAND 差异
- NOR：可 XIP、擦除块较大、寿命长。
- NAND：容量大、需 **ECC 与坏块管理**、按页读写。

### 注意
- **写错分区会变砖**：务必先确认分区映射再写。
- 覆盖引导固件前，先确认 [[BootROM]] 的恢复路径（见 [[BootROM]]）。

## 相关笔记
- [[嵌入式基础概念 MOC]]
- [[内存映射与地址布局]]
- [[引导加载器（Bootloader）]]
- [[RV2 引导链与固件]]

## 引用
- mtd-utils：<https://git.infraroot.at/mtd-utils/>
