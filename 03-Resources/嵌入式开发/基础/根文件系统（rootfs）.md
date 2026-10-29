---
title: 根文件系统（rootfs）
created: "2026-10-17T23:21:39+08:00"
modified: "2026-10-17T23:21:39+08:00"
tags:
  - embedded
  - rootfs
  - kernel
category: 嵌入式基础
source: https://gitlab.com/buildroot.org/buildroot
url: https://gitlab.com/buildroot.org/buildroot
---

# 根文件系统（rootfs）

> 上级：[[嵌入式基础概念 MOC]]

## 概述
- 内核挂载的**根文件系统**：提供用户态所需的一切——`/bin`、`/lib`、`/etc`、`init` 等。
- 没有它，内核走到"找不到 init"就会 panic。

## 关键要点

### 最小组成
- `init`（首个进程）、shell 与基础工具、C 库、`/etc` 配置。
- 虚拟文件系统挂载点：`/dev`、`/proc`、`/sys`、`/tmp`。
- **BusyBox**：精简的多合一工具集，最小 rootfs 的常见基础。

### 形态
- **initramfs / initrd**：打包进内核或由 bootloader 传入，在内存中解压。
- **磁盘分区**（ext4 / f2fs）**或只读镜像**（squashfs + overlay）。
- **网络根**（NFS / TFTP）：开发调试常用。

### 生成方式
| 方式 | 特点 |
|------|------|
| **Buildroot** | 轻量、一条命令出 rootfs（可含内核 + 引导） |
| **Yocto** | 可维护、可追溯，`core-image-*` |
| **OpenWrt** | 网络导向 |
| 手动 | BusyBox + 交叉工具链 + `mkfs` |

- RV2 实例见 [[RV2 根文件系统]]。

### 常见坑
- 文件权限 / 属主、动态库缺失（`ldd` 检查）。
- `/dev` 与 `devtmpfs`、只读挂载的时序。
- `/etc/inittab` 或 init 缺失导致无法进入用户态。

## 相关笔记
- [[嵌入式基础概念 MOC]]
- [[内核与 init 流程]]
- [[交叉编译与工具链]]
- [[RV2 根文件系统]]

## 引用
- Buildroot：<https://gitlab.com/buildroot.org/buildroot>
- BusyBox：<https://busybox.net/>
