---
title: RV2 常见问题与资源
created: "2026-10-17T20:35:34+08:00"
modified: "2026-10-17T22:28:52+08:00"
tags:
  - embedded
  - board
---

# RV2 常见问题与资源

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 从零构建嵌入式系统]]、[[RV2 内核与设备树]]

## 已知问题 / 注意点
- **SPI-NOR 与引导**：引导固件（FSBL / OpenSBI / U-Boot）在 SPI-NOR；**刷 SD/eMMC 不改动它**。
- **串口电平**：DEBUG 为 3.3V，务必用 3.3V USB-TTL。
- **microSD（6.18）**：`sdhci-of-k1` 未使能 SD pad clock → 卡初始化静默失败（U-Boot 能读、Linux 不行）；需补丁（upstream `f87b273e4b6d` 已修，回移即可）。
- **WiFi（AP6256）**：需 PMIC 32KOUT（32.768kHz LPO）与 GPIO 116 门控 EXT_3V3，时序不对报 `clock enable timeout`。
- **以太网**：6.18 edge 内核链路抖动（flapping），6.6 正常。
- **mainline DTS 尚简**：`k1-orangepi-rv2.dts` 仅 UART + LED；补外设需回移 mainline-master 的 K1 DTS 系列。
- **OpenSBI/U-Boot 兼容**：mainline OpenSBI 与 vendor U-Boot 设备树不匹配，需补丁对齐（见 [[RV2 引导链与固件]]）。

## 开源标准资源（主用）
- 上游 Linux（K1）：<https://github.com/torvalds/linux>（`arch/riscv/boot/dts/spacemit/`）
- SpacemiT 上游内核镜像：<https://github.com/spacemit-com/linux>
- OpenSBI：<https://github.com/riscv-software-src/opensbi>
- U-Boot（K1 现状，社区）：<https://github.com/pyavitz/spacemit-u-boot>
- Buildroot：<https://gitlab.com/buildroot.org/buildroot>
- Yocto meta-riscv：<https://git.yoctoproject.org/meta-riscv/>
- OpenWrt（spacemit target）：<https://github.com/openwrt/openwrt>
- riscv-gnu-toolchain：<https://github.com/riscv-collab/riscv-gnu-toolchain>
- Rust：<https://rustup.rs>（见 [[RV2 Rust 开发指南]]）
- SpacemiT 上游进度看板：<https://github.com/spacemit-com/.github/blob/main/profile/README.md>

## 厂商资料（仅参考，不直接使用）
- 官方 wiki：<http://www.orangepi.org/orangepiwiki/index.php/Orange_Pi_RV2>
- 产品页 / 下载：<http://www.orangepi.cn/html/hardWare/computerAndMicrocontrollers/service-and-support/Orange-Pi-RV2.html>
- orangepi-build：<https://github.com/orangepi-xunlong/orangepi-build>
- WiringOP：<https://github.com/orangepi-xunlong/WiringOP>
- Bianbu 文档：<https://bianbu.spacemit.com/>
- SpacemiT 工具链：<http://archive.spacemit.com/toolchain/>
- Armbian（社区，参考）：<https://github.com/armbian/build/blob/main/config/sources/families/spacemit.conf>

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 从零构建嵌入式系统]]
- [[RV2 内核与设备树]]
- [[RV2 GPIO 与外设]]
- [[嵌入式项目踩坑记录]]
