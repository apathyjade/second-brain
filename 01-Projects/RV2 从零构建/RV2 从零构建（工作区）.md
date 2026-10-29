---
title: RV2 从零构建（工作区）
created: "2026-10-17T22:41:33+08:00"
modified: "2026-10-17T22:53:41+08:00"
tags:
  - project
  - embedded
  - board
status: active
area: 嵌入式开发
deadline:
---

# RV2 从零构建（工作区）

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 从零构建嵌入式系统]]、[[RV2 引导链与固件]]、[[RV2 根文件系统]]

本目录是 RV2「从零构建」的**可复现构建工作区**：用标准开源栈，从固件到 rootfs 到应用，一条链路可编排、可版本化。
设计理念与路线图见 [[RV2 从零构建嵌入式系统]]。

## 目标
- 用 Makefile + 脚本把 `fetch → OpenSBI → U-Boot → Linux → FIT → SD 镜像 → SPI-NOR` 串起来。
- 全部组件来自上游/社区开源；厂商物**仅参考**。
- 产出可复现的 `out/` 与可写入介质的镜像。

> 说明：本工作区**只做编排与脚手架**，不含实际编译产物；执行需自备工具链与网络（见「环境依赖」）。

## 关键路径
1. `make check` —— 检查主机依赖
2. `make fetch` —— 克隆 OpenSBI / U-Boot / Linux 到 `src/`
3. `make opensbi uboot linux` —— 分别构建固件与内核到 `out/`
4. `make fit` —— 用 `mkimage` 打包 `out/boot-bundle.itb`
5. `make sdcard` —— 用 `genimage` 生成 `out/rv2-sdcard.img`
6. `make spiflash` —— 板内写 SPI-NOR（引导固件）

## 目录结构
```
RV2 从零构建/
├── RV2 从零构建（工作区）.md   # 本笔记
├── Makefile                    # 顶层编排
├── .gitignore
├── configs/
│   ├── boot-bundle.its         # FIT 源（OpenSBI + U-Boot + Linux + dtb）
│   ├── genimage.cfg            # SD 镜像分区布局
│   ├── extlinux.conf           # 引导项（内核 + fdt + cmdline）
│   └── linux-k1.fragment       # mainline 内核配置片段
├── scripts/                    # 分步脚本（见下）
├── rust/hello/                 # Rust 交叉编译示例
├── src/                        # （生成）克隆的源码，已忽略
└── out/                        # （生成）构建产物，已忽略
```

## 脚本一览
| 脚本 | 作用 |
|------|------|
| `00-check-env.sh` | 检查主机工具链与依赖 |
| `10-fetch-sources.sh` | 克隆 OpenSBI / U-Boot / Linux（幂等） |
| `20-build-opensbi.sh` | 构建 mainline OpenSBI（generic, `fw_dynamic`） |
| `21-build-uboot.sh` | 构建 U-Boot（`k1_defconfig`） |
| `22-build-linux.sh` | 构建 mainline Linux（`Image` + dtb） |
| `30-make-fit.sh` | 生成 `boot-bundle.itb` |
| `40-make-sdcard.sh` | 生成 SD 卡镜像（genimage） |
| `90-flash-spinor.sh` | 板内写 SPI-NOR（mtd-utils / U-Boot `sf`） |

## 可覆盖变量（`make VAR=...`）
- `CROSS_COMPILE`（默认 `riscv64-linux-gnu-`）
- `SRC`（默认 `src`）、`OUT`（默认 `out`）、`JOBS`（默认 CPU 核数）
- `OPENSBI_REF` / `UBOOT_REPO` / `UBOOT_REF` / `LINUX_REF`（源码版本）
- `UBOOT_REPO` 默认指向社区 K1 树（上游 U-Boot 对 K1 仍 WIP，见 [[RV2 引导链与固件]]）；上游就绪后可改为主线。

## 环境依赖
- 基础：`git` / `make` / `python3`
- 交叉工具链：`riscv64-linux-gnu-gcc`（或 LLVM/Clang）
- 固件与镜像：`u-boot-tools`(mkimage) / `device-tree-compiler`(dtc) / `genimage` / `dosfstools` / `e2fsprogs`
- 应用层：`rustup` + `cargo`
- 板内烧录：`mtd-utils`(flashcp/flash_erase)
- macOS 可用 Homebrew 安装；Debian/Ubuntu 用 apt。运行 `make check` 查看缺项。

## 资源 / 相关笔记
- [[OrangePi RV2 MOC]] —— 开发板总入口
- [[RV2 从零构建嵌入式系统]] —— 理念、开源工具矩阵、6 阶段路线图
- [[RV2 引导链与固件]] —— FSBL / OpenSBI / U-Boot / FIT
- [[RV2 内核与设备树]] —— mainline Linux 与 `k1-orangepi-rv2.dts`
- [[RV2 根文件系统]] —— Buildroot / Yocto / OpenWrt
- [[RV2 系统构建]] —— 内核 + rootfs + 引导 → 可烧录镜像
- [[RV2 烧录（balenaEtcher）]] —— balenaEtcher 写卡
- [[RV2 Rust 开发指南]] —— Rust 交叉编译
- [[工具链与构建 MOC]]

## 待办
- [ ] 打通 `make check → fetch → opensbi/uboot/linux → fit` 的干跑与实编
- [ ] 接入 rootfs（Buildroot / Yocto 产物）到 `genimage.cfg`
- [ ] 核对社区 U-Boot 树的产物名（`FSBL.bin` / `bootinfo_spinor.bin` 等）
- [ ] 板内验证 `90-flash-spinor.sh` 的分区映射

## 里程碑
- [ ] 主机侧可一键产出 `boot-bundle.itb`
- [ ] 产出可启动的 SD 镜像
- [ ] 首次自建系统在 RV2 上串口点灯
