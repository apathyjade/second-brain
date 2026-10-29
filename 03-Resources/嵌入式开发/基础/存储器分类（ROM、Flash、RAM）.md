---
title: 存储器分类（ROM、Flash、RAM）
created: "2026-10-19T03:03:58+08:00"
modified: "2026-10-19T03:03:58+08:00"
tags:
  - embedded
  - storage
  - memory
category: 嵌入式基础
source: https://git.infraroot.at/mtd-utils/
url: https://git.infraroot.at/mtd-utils/
---

# 存储器分类（ROM、Flash、RAM）

> 上级：[[嵌入式基础概念 MOC]]

## 概述
- 嵌入式里的存储器按**两个轴**分类：**易失 / 非易失**（掉电丢不丢）× **可写性**（一次 / 块擦写 / 字节改写 / 只读）。
- 名称混乱的根源：**"ROM" 一词今天至少有三重含义**，而口语里的 "ROM" 往往根本不是只读的。
- 另一个决定性属性是 **能不能就地执行（XIP）** —— 它直接决定了"代码能不能直接从这片存储上跑"。

## 关键要点

### 总览表

| 名称 | 易失? | 可写性 | 容量/成本 | 嵌入式里的位置与用途 |
|------|-------|--------|-----------|---------------------|
| **SRAM** | 是 | 随时 | 小 / 贵 | **片内**：栈、堆、BootROM 的运行内存 |
| **DRAM（DDR）** | 是 | 随时 | 大 / 便宜 | **片外**：主内存，Linux 的运行基础 |
| **掩膜 ROM (Mask ROM)** | 否 | **出厂后不可写** | 小 | 片内硅片：[[BootROM]] |
| **OTP / eFuse** | 否 | **一次** | 极小 | 片内：密钥、MAC、芯片型号、启动配置 |
| **EEPROM** | 否 | **字节级改写** | 小 / 贵 | 片内或外挂 I²C：校准参数、小配置 |
| **NOR Flash** | 否 | **块擦写** | 中 | 外挂 SPI-NOR：**引导固件**，**可 XIP** |
| **NAND Flash** | 否 | **块/页擦写** | 大 / 便宜 | SPI-NAND / eMMC / UFS：rootfs、数据 |
| **eMMC / SD 卡** | 否 | 块擦写 | 大 | 系统盘（含控制器 + 坏块管理 + FTL） |
| **NVMe SSD** | 否 | 块擦写 | 很大 / 快 | PCIe 系统盘 |

> eMMC / SD / NVMe 本质都是 **NAND + 控制器**，对外暴露成**块设备**（`/dev/mmcblk*`、`/dev/nvme*`），与裸 NAND 走 [[存储分区与 MTD]] 的 MTD 子系统不同。

### 「ROM」一词的三重含义（关键澄清）

| 语境 | 指什么 | 实际可写吗 |
|------|--------|-----------|
| 严格 / 硬件手册 | **掩膜 ROM**：流片时写入，永不可改 | ❌ |
| 日常口语（"刷 ROM"、"ROM 不够") | 通常指板上那片 **NOR / eMMC**，指代"存放系统的存储" | ✅ 可刷 |
| 引导语境 | **BootROM**：SoC 固化的第一段引导代码（见 [[BootROM]]） | ❌ |

**结论**：听到 "ROM" 先问一句"哪一层"。**"刷 ROM" 99% 是指刷 NOR / eMMC，而不是真的写入只读存储器。**

### XIP（eXecute In Place，就地执行）
- **NOR 可以 XIP**：有地址线，CPU 能像读内存一样随机取指 —— 所以 MCU 的代码直接放在片内 Flash 上跑。
- **NAND 不能 XIP**：按页访问、需要 ECC 与坏块管理，必须先搬进 RAM。
- **这就是 MCU 与 SoC 引导差异的物理根源**：MCU 从 Flash 取指（1 级），RV2 必须把内核 `Image` 搬进 DRAM（多级，见 [[启动流程（Boot Flow）]]）。
- 你把内核打包进 FIT 时填的 `load` 地址（见 [[FIT 镜像]]），本质就是"搬到 DRAM 的哪里"。

### 一次完整视角：RV2（K1）的存储分工

| 存储 | 位置 | 放什么 | 可写 |
|------|------|--------|------|
| 掩膜 ROM | SoC 片内 | [[BootROM]] | ❌ |
| SRAM | SoC 片内 | BootROM / FSBL 的运行内存 | ✅ |
| OTP / eFuse | SoC 片内 | 启动配置、密钥 | 一次 |
| SPI-NOR（XM25QU128C，128Mb） | 板上 | FSBL / OpenSBI / U-Boot | ✅ 需 `flashcp` |
| DRAM（LPDDR4X 8 GB） | 板上 | Linux 运行时 | ✅ 掉电即失 |
| SD / eMMC / NVMe | 插槽/板上 | 内核 `Image` + `k1-orangepi-rv2.dtb` + rootfs | ✅ 写入镜像 |

### 选型直觉
- **要掉电保存 + 要能执行代码** → NOR Flash（贵、小、可 XIP）
- **要掉电保存 + 要容量** → NAND / eMMC / SD（便宜、大、不可 XIP）
- **要频繁改的小参数** → EEPROM（可字节改，不必整块擦）
- **要保密且不可改** → OTP / eFuse
- **运行期主存** → DRAM（大）+ SRAM（快）

### 常见误解
- ❌ "RAM 是存储" —— 掉电即失，所以**引导链的任何一段都必须放在非易失介质**上。
- ❌ "Flash 可以像文件一样改一个字节" —— NOR/NAND 是**块擦写**：改 1 字节要先擦整块再回写。这正是根文件系统常用**只读 + overlay** 的原因（见 [[根文件系统（rootfs）]]）。
- ❌ "Flash 寿命无限" —— 有擦写次数上限（NOR 十万级、NAND 千级）；频繁写的日志/配置要另想办法（overlay、tmpfs、只读 rootfs）。

## 相关笔记
- [[嵌入式基础概念 MOC]]
- [[芯片分类（MCU、MPU、SoC）]]
- [[BootROM]]
- [[存储分区与 MTD]]
- [[内存映射与地址布局]]
- [[FIT 镜像]]
- [[根文件系统（rootfs）]]
- [[启动流程（Boot Flow）]]

## 引用
- mtd-utils（Flash 操作工具集）：<https://git.infraroot.at/mtd-utils/>
- Linux MTD 子系统：<https://www.kernel.org/doc/html/latest/driver-api/mtdnand.html>
