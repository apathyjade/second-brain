---
title: 内核与 init 流程
created: "2026-10-17T23:21:39+08:00"
modified: "2026-10-17T23:21:39+08:00"
tags:
  - embedded
  - kernel
category: 嵌入式基础
source: 
url: 
---

# 内核与 init 流程

> 上级：[[嵌入式基础概念 MOC]]

## 概述
- bootloader 移交控制权后，**内核**接管：初始化内存 / 中断 / 驱动 → 挂载 [[根文件系统（rootfs）]] → 启动第一个用户态进程 `init`。

## 关键要点

### 内核启动大致阶段
1. 解压 / 自解压，建立早期内存映射。
2. 解析 [[设备树（Device Tree）]]，注册平台设备与驱动。
3. 初始化子系统（调度、内存管理、驱动模型），probe 驱动。
4. 挂载 rootfs（`root=` 或从 initrd / initramfs 切换）。
5. 执行 `/sbin/init`（或 systemd）。

### 关键参数（内核命令行 cmdline）
- `console=<dev>,<baud>`：控制台（如 `ttyS0,115200`）。
- `root=` / `rootwait` / `rw` / `ro`：根文件系统位置与挂载方式。
- `init=`：指定 init 程序。
- 由 bootloader 传入（U-Boot 的 `bootargs`，或 FIT 配置）。

### init 与用户态
- **BusyBox init**：读 `/etc/inittab`，执行 `rcS` 启动脚本。
- **systemd**：按 unit 依赖图并行启动。
- 只读 rootfs + **overlay** 的常见方案（见 [[根文件系统（rootfs）]]）。

### 调试
- 早期串口日志、`earlycon`；`quiet` / `loglevel` 控制输出。
- panic / 卡在 `Waiting for root device` 多为 rootfs 或 cmdline 问题。

## 相关笔记
- [[嵌入式基础概念 MOC]]
- [[启动流程（Boot Flow）]]
- [[设备树（Device Tree）]]
- [[根文件系统（rootfs）]]

## 引用
- Linux 内核文档：<https://docs.kernel.org/>
