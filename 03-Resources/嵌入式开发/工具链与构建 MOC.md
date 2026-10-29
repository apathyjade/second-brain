---
title: 工具链与构建 MOC
created: "2026-10-17T19:31:06+08:00"
modified: "2026-10-17T22:28:52+08:00"
tags:
  - moc
  - embedded
---

# 工具链与构建 MOC

> 上级：[[嵌入式开发 MOC]]

## 概览
- 交叉编译、构建系统与烧录工具链。

## 核心笔记
- 编译器：arm-none-eabi-gcc、Clang、厂商工具链
- 构建系统：Makefile、CMake、PlatformIO、Zephyr west、Kconfig
- **Rust 工具链**：`rustup` / `cargo` / `cross` / `embedded-hal`（RV2 示例见 [[RV2 Rust 开发指南]]）
- 引导与固件：**OpenSBI**、**U-Boot**、FIT 打包（RV2 见 [[RV2 引导链与固件]]）
- 根文件系统：**Buildroot** / **Yocto** / **OpenWrt**（RV2 见 [[RV2 根文件系统]]）
- 烧录：OpenOCD、ST-Link、esptool、J-Link、DFU、mtd-utils

## 从零构建实例
- [[RV2 从零构建嵌入式系统]] —— 从裸板到应用的完整开源链路（固件 → 内核 → rootfs → 应用）
- [[RV2 从零构建（工作区）]] —— 可复现构建工作区（Makefile + 脚本 + configs）

## 派生 / 子主题
- 交叉编译环境搭建
- 嵌入式 Rust：`no_std`（裸机）与 std（Linux 用户态）、交叉编译目标三元组
- 链接脚本与内存布局
- 固件打包与 OTA 升级
- CI 构建与自动化

## 待整理
- 
