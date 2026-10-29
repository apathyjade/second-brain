---
title: RV2 引导链与固件
created: "2026-10-17T22:28:52+08:00"
modified: "2026-10-17T23:21:39+08:00"
tags:
  - embedded
  - board
  - firmware
  - bootloader
source: https://github.com/riscv/meta-riscv/blob/master/docs/orangepi-rv2-mainline.md
url: https://github.com/riscv-software-src/opensbi
---

# RV2 引导链与固件

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 系统构建]]、[[RV2 烧录（balenaEtcher）]]、[[RV2 内核与设备树]]

## 引导链
```
BootROM → FSBL.bin → OpenSBI(fw_dynamic) → U-Boot → Linux(Image + dtb)
                  (存放于 SPI-NOR / eMMC / SD)
```

## 各段来源
| 段 | 来源 | 性质 |
|----|------|------|
| BootROM | SoC 固化 | 不可改 |
| FSBL.bin | SpacemiT 开源 U-Boot 树（配方 `u-boot-spl-k1`，GPL） | **厂商开源，非上游**（唯一例外） |
| OpenSBI | **mainline OpenSBI**（`platform/generic/spacemit/k1.c`） | 上游 |
| U-Boot | **mainline U-Boot**（K1 上游 WIP）或社区树 | 上游/社区 |
| Linux | **mainline Linux** | 上游 |

## mainline OpenSBI（K1）
- 上游 `platform/generic/spacemit/k1.c` 已支持 K1；OpenSBI **v1.9** 起含 reboot patchset（依赖 SpacemiT P1 PMIC 节点）。
- ⚠️ mainline OpenSBI 与 vendor U-Boot 的**设备树差异**会导致不兼容；需给 U-Boot 打补丁对齐（参考 Aurélien Jarno 的 `k1-bl-v2.2.y-opensbi` 分支做法），或统一采用社区 K1 树。

## U-Boot 现状
- 上游 U-Boot 对 K1 仅**基础二级引导**；SPL 支持（`[PATCH 00/17] Add board support for Spacemit K1 SoC in SPL`）2026-01 已投递但**尚未合入**。
- 现阶段实用：社区 `pyavitz/spacemit-u-boot`（tag `k1-bl-v2.2.9-release`）或 SpacemiT 开源树。
- 目标配置：`k1_defconfig`；产物含 `FSBL.bin`、`bootinfo_spinor.bin`、`bootinfo_emmc.bin`、`fw_dynamic.itb`、`u-boot.itb`、`u-boot-env-default.bin`。

## 引导捆绑（FIT）
- 用 FIT（`boot-bundle.itb`）一次打包，U-Boot 启动时内核与 dtb 已在 RAM：
  - mainline U-Boot：`u-boot-nodtb.bin` + `u-boot.dtb`
  - mainline OpenSBI：`fw_dynamic.bin`
  - mainline Linux：`Image` + `k1-orangepi-rv2.dtb`

## 编译（示意）
```bash
# OpenSBI（mainline）
make -C opensbi CROSS_COMPILE=riscv64-linux-gnu- \
     PLATFORM=generic PLATFORM_DEFCONFIG=k1_defconfig
# U-Boot（指定 OpenSBI 固件）
make -C u-boot k1_defconfig
make -C u-boot CROSS_COMPILE=riscv64-linux-gnu- \
     OPENSBI=/path/to/fw_dynamic.bin
```

## 写入 SPI-NOR（标准方法）
- 板内（系统启动后，标准内核 MTD 接口）：
```bash
flash_erase /dev/mtdX 0 0
flashcp FSBL.bin       /dev/mtdX     # 依分区表写到对应分区
flashcp fw_dynamic.itb /dev/mtdX
flashcp u-boot.itb     /dev/mtdX
```
- 或在 U-Boot 里用 `sf probe` / `sf update` 写 SPI-NOR。
- ⚠️ RV2 的 SPI-NOR 型号为 **XM25QU128C**（XMC 128Mb）；分区偏移与大小以实际分区表为准。
- 说明：**刷 SD/eMMC 不会改动 SPI-NOR**；引导介质由 U-Boot 选择。

## 注意
- 上游 OpenSBI + vendor U-Boot 需补丁对齐设备树；建议统一采用社区 K1 树或自行回移补丁。
- FSBL 是唯一"厂商开源但非上游"环节，短期无法完全脱离。

## 基础概念
> 通用原理见 [[嵌入式基础概念 MOC]]
- [[BootROM]] —— SoC 固化第一段，不可改；决定启动介质顺序
- [[引导加载器（Bootloader）]] —— 一级（FSBL/SPL）/ 二级（U-Boot）职责
- [[固件（Firmware）]] —— OpenSBI 等低层运行时
- [[FIT 镜像]] —— `boot-bundle.itb` 的格式
- [[存储分区与 MTD]] —— SPI-NOR 分区与 `flashcp` 刷写

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 系统构建]]
- [[RV2 从零构建嵌入式系统]]
- [[RV2 内核与设备树]]
- [[RV2 烧录（balenaEtcher）]]

## 引用
- meta-riscv RV2 mainline：<https://github.com/riscv/meta-riscv/blob/master/docs/orangepi-rv2-mainline.md>
- 上游 OpenSBI on K1（blog）：<https://blog.aurel32.net/upstream-opensbi-spacemit-k1.html>
- U-Boot SPL 补丁系列：<https://lists.denx.de/pipermail/u-boot/2026-January/608467.html>
- SpacemiT 上游进度：<https://github.com/spacemit-com/.github/blob/main/profile/README.md>
