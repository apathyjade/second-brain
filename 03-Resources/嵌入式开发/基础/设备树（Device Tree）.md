---
title: 设备树（Device Tree）
created: "2026-10-17T23:21:39+08:00"
modified: "2026-10-17T23:21:39+08:00"
tags:
  - embedded
  - devicetree
  - kernel
category: 嵌入式基础
source: https://www.devicetree.org/
url: https://www.devicetree.org/
---

# 设备树（Device Tree）

> 上级：[[嵌入式基础概念 MOC]]

## 概述
- 用**数据**描述硬件（地址、中断、时钟、引脚复用等），让**同一个内核**适配不同板子，避免把板级信息硬编码进内核源码。
- 源文件 `.dts` / `.dtsi` → 编译为二进制 `.dtb` → 由 bootloader 或内核读取。

## 关键要点

### 组成
- `.dts`：板级描述；`.dtsi`：被 include 的公共片段（通常 SoC 级）。
- `.dtb`：编译产物（工具 `dtc`）。
- **binding**：节点 / 属性的规范化文档（`Documentation/devicetree/bindings`）。

### 常见节点与属性
- `compatible`：驱动匹配的关键字（最重要）。
- `reg`：地址与长度；`interrupts`：中断号；`clocks`、`resets`、`pinctrl-*`。
- `status = "okay" / "disabled"`：启用或禁用某外设。

### 传递与覆盖
- bootloader 把 dtb 地址交给内核；或与内核一起打包进 [[FIT 镜像]]。
- **overlay（`.dtbo`）**：在基础 dtb 上追加/修改节点（如加装传感器）。
- 运行时查看：`/proc/device-tree`、`/sys/firmware/devicetree`。

### 常见坑
- mainline dtb 与厂商 dtb 差异 → 驱动不匹配（RV2 见 [[RV2 内核与设备树]]）。
- 属性拼写 / 单位错误 → 驱动 probe 失败。

## 相关笔记
- [[嵌入式基础概念 MOC]]
- [[内核与 init 流程]]
- [[FIT 镜像]]
- [[RV2 内核与设备树]]

## 引用
- Devicetree 规范：<https://www.devicetree.org/>
