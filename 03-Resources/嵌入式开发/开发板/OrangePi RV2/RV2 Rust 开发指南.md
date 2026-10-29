---
title: RV2 Rust 开发指南
created: "2026-10-17T22:05:02+08:00"
modified: "2026-10-17T22:28:52+08:00"
tags:
  - embedded
  - board
  - rust
  - toolchain
source: https://doc.rust-lang.org/stable/rustc/platform-support/riscv64gc-unknown-linux-gnu.html
url: https://github.com/cross-rs/cross
---

# RV2 Rust 开发指南

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 Rust 外设编程]]、[[RV2 工具链与编译]]

## 为什么用 Rust
- 内存安全、无 GC、单二进制部署，适合长期运行的嵌入式 Linux 服务。
- 交叉编译成熟（`rustup` 直接提供 RISC-V 目标），外设访问有 `embedded-hal` 生态（见 [[RV2 Rust 外设编程]]）。

## 目标平台
| 项 | 值 |
|----|----|
| Rust target | `riscv64gc-unknown-linux-gnu`（RV64GC + glibc） |
| K1 实际 ISA | `rv64imafdcbv` + `zba/zbb/zbc/zbs/zfh/zvfh`（含 256-bit RVV 1.0、bitmanip） |
| 说明 | `riscv64gc` **不含** `v`（向量）；需向量加速时见下方「RVV / 性能优化」 |

## 安装工具链
```bash
# 主机（Linux/macOS）安装 rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add riscv64gc-unknown-linux-gnu   # 只需添加这一个目标
```
- 交叉链接器：装 GCC 交叉工具链 `sudo apt install gcc-riscv64-linux-gnu`；或用 SpacemiT 工具链的 `riscv64-unknown-linux-gnu-gcc`（见 [[RV2 工具链与编译]]）。

## 交叉编译配置（.cargo/config.toml）
```toml
[build]
target = "riscv64gc-unknown-linux-gnu"     # 默认交叉编译

[target.riscv64gc-unknown-linux-gnu]
linker = "riscv64-linux-gnu-gcc"           # 必填：否则链接失败
# runner = "qemu-riscv64 -L /usr/riscv64-linux-gnu"   # 主机上可直接 cargo run
```
- 不想写文件：`export CARGO_TARGET_RISCV64GC_UNKNOWN_LINUX_GNU_LINKER=riscv64-linux-gnu-gcc`
- 若工具链不在 `PATH`，逐项指定：`cc` / `cxx` / `ar` / `ranlib` / `linker`。
- 静态链接（推荐部署，单文件无运行时依赖）：
```toml
[target.riscv64gc-unknown-linux-gnu]
rustflags = ["-C", "target-feature=+crt-static"]
```

## Hello World → 部署
```bash
cargo new rv2-hello && cd rv2-hello
cargo build --release                       # 因 [build].target，产物已是 RISC-V
file target/riscv64gc-unknown-linux-gnu/release/rv2-hello   # 应显示 UCB RISC-V
scp target/riscv64gc-unknown-linux-gnu/release/rv2-hello orangepi@<ip>:~/
ssh orangepi@<ip> ./rv2-hello
```

## 用 cross（免装交叉工具链）
```bash
cargo install cross
cross build --release --target riscv64gc-unknown-linux-gnu
```
- `cross` 在容器里完成链接，主机无需安装 GCC 交叉包。

## 原生编译（板上）
- RV2 装上 rustup 后可直接本机 `cargo build --release`（8 核），中小项目够用。

## RVV / 性能优化
- `riscv64gc` 不含向量。要利用 K1 的 256-bit RVV 1.0，需 nightly：
```bash
rustup toolchain install nightly
rustup +nightly component add rust-src
# 通过 -Zbuild-std 或 -C target-feature=+v 打开向量
```
- GCC 侧参考：`-mcpu=spacemit-x60 -march=rv64gc_zba_zbb_zbc_zbs`（bitmanip；加 `v` 开 RVV，建议 gcc14）。
- 注意：RVV 代码在 K1 上需较新工具链，旧版 API/宏会报错（社区反馈）。

## 常用 crate
| 用途 | crate |
|------|-------|
| CLI | `clap` |
| 异步运行时 | `tokio` |
| 序列化 | `serde` / `serde_json` / `toml` |
| 错误处理 | `anyhow` / `thiserror` |
| 日志 | `tracing` + `tracing-subscriber` |
| 外设 | `linux-embedded-hal` / `gpio-cdev` / `i2cdev` / `spidev`（见 [[RV2 Rust 外设编程]]） |
| CAN | `socketcan` |
| 串口 | `serialport` |

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 从零构建嵌入式系统]]
- [[RV2 根文件系统]]
- [[RV2 Rust 外设编程]]
- [[RV2 工具链与编译]]
- [[RV2 内核与设备树]]
- [[工具链与构建 MOC]]

## 引用
- rustc 平台支持：<https://doc.rust-lang.org/stable/rustc/platform-support/riscv64gc-unknown-linux-gnu.html>
- cross：<https://github.com/cross-rs/cross>
- K1 DTS（ISA 声明）：<https://github.com/torvalds/linux/blob/master/arch/riscv/boot/dts/spacemit/k1.dtsi>
