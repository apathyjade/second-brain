---
title: FIT 镜像
created: "2026-10-17T23:21:39+08:00"
modified: "2026-10-17T23:21:39+08:00"
tags:
  - embedded
  - boot
  - bootloader
category: 嵌入式基础
source: https://docs.u-boot.org/en/latest/usage/fit/index.html
url: https://docs.u-boot.org/en/latest/usage/fit/index.html
---

# FIT 镜像

> 上级：[[嵌入式基础概念 MOC]]

## 概述
- **Flattened Image Tree**：U-Boot 的镜像容器格式。用一个 `.itb` 把**内核、设备树、固件、initrd、脚本**打包，并可带校验 / 签名。
- 其描述语法 = [[设备树（Device Tree）]]。

## 关键要点

### 结构
- 源文件 `.its`（image tree source）→ `mkimage -f` 编译 → `.itb`（本质是带 FIT 头的 dtb）。
- 主要节点：
  - `/images`：各载荷（+ 类型 / 压缩 / 加载地址 / 入口）
  - `/configurations`：载荷组合，含默认项

### 优点
- 单一文件承载多组件，bootloader 一条命令加载。
- 支持 **hash 校验**与 **RSA 签名**（安全启动）。
- 一份 `.itb` 可含多配置（多板 / 多 dtb）。

### 典型命令
```bash
mkimage -f boot-bundle.its boot-bundle.itb
# U-Boot 内
bootm <addr>        # 按 FIT 配置启动
```

### 相关实例
- RV2 的引导捆绑（OpenSBI + U-Boot + 内核）即用 FIT，见 [[RV2 引导链与固件]]。

## 相关笔记
- [[嵌入式基础概念 MOC]]
- [[设备树（Device Tree）]]
- [[引导加载器（Bootloader）]]
- [[固件（Firmware）]]

## 引用
- U-Boot FIT 文档：<https://docs.u-boot.org/en/latest/usage/fit/index.html>
