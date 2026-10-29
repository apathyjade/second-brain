---
title: RV2 Rust 外设编程
created: "2026-10-17T22:05:02+08:00"
modified: "2026-10-17T22:05:02+08:00"
tags:
  - embedded
  - board
  - rust
  - gpio
source: https://github.com/rust-embedded/linux-embedded-hal
url: https://docs.rs/linux-embedded-hal
---

# RV2 Rust 外设编程

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 Rust 开发指南]]、[[RV2 GPIO 与外设]]

## 思路
- Linux 用户态下，用 `embedded-hal` 定义的 **trait** 编写设备驱动，由 `linux-embedded-hal` 把 GPIO / I2C / SPI / 串口适配到 Linux 设备节点。
- GPIO 走 **字符设备**（`/dev/gpiochip*`，kernel ≥ 4.4；sysfs GPIO 已弃用）。

## 依赖
```toml
[dependencies]
embedded-hal = "1"
linux-embedded-hal = { version = "0.4", features = ["gpio_cdev", "i2c", "spi"] }
# 也可只用底层 crate：
# gpio-cdev = "0.6"
# i2cdev = "0.6"
# spidev = "0.7"
```
- feature：`gpio_cdev`（推荐）/ `gpio_sysfs`（旧）/ `i2c` / `spi` / `serial` / `async-tokio`。

## GPIO（字符设备）
```rust
use embedded_hal::digital::OutputPin;
use linux_embedded_hal::CdevPin;
use gpio_cdev::{Chip, LineRequestFlags};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let chip = Chip::new("/dev/gpiochip0")?;
    let line = chip.get_line(17)?;                  // line 号用 `gpioinfo` 查
    let handle = line.request(LineRequestFlags::OUTPUT, 0, "led")?;
    let mut led = CdevPin::new(handle)?;
    led.set_high()?;
    Ok(())
}
```
- 查芯片/线号：`gpiodetect` / `gpioinfo`（见 [[RV2 GPIO 与外设]]）。

## I2C
```rust
use embedded_hal::i2c::I2c;
use linux_embedded_hal::I2cdev;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut i2c = I2cdev::new("/dev/i2c-1")?;
    let mut val = [0u8; 2];
    i2c.write_read(0x50, &[0x00], &mut val)?;       // 读寄存器 0x00
    println!("{:?}", val);
    Ok(())
}
```

## SPI
- 底层 `spidev` crate（半双工 + 全双工 ioctl）：
```rust
use spidev::{Spidev, SpidevOptions, SpiModeFlags};
use std::io::{Read, Write};

fn main() -> std::io::Result<()> {
    let mut spi = Spidev::open("/dev/spidev0.0")?;
    let opts = SpidevOptions::new()
        .bits_per_word(8)
        .max_speed_hz(1_000_000)
        .mode(SpiModeFlags::SPI_MODE_0)
        .build();
    spi.configure(&opts)?;
    spi.write(&[0x9F, 0, 0, 0])?;                   // 例：读 JEDEC ID
    let mut rx = [0u8; 4];
    spi.read(&mut rx)?;
    println!("{:02X?}", rx);
    Ok(())
}
```
- 或 `linux-embedded-hal::SpidevDevice` / `SpidevBus`（实现 `embedded-hal` 的 `SpiDevice` / `SpiBus`，便于复用生态驱动）。

## PWM
- 无 `embedded-hal` 适配；走 sysfs `/sys/class/pwm`（`sysfs-pwm` crate 或直接写文件）：
```text
echo 0 > /sys/class/pwm/pwmchip0/export
echo 1000000 > /sys/class/pwm/pwmchip0/pwm0/period      # 1ms
echo  500000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle  # 50%
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
```

## CAN
- `socketcan` crate（SocketCAN 绑定）；命令行对照 `ip link set canX up` + `can-utils`。

## 串口
- `serialport` crate（`linux-embedded-hal` 的 `serial` feature 亦封装它）。

## 权限
- `/dev/gpiochip*`、`/dev/i2c-*`、`/dev/spidev*`、`/sys/class/pwm` 需权限：加 udev 规则 / 加入用户组，或临时 `sudo`。

## 与其他方式对照
| 语言/工具 | GPIO | I2C | SPI |
|-----------|------|-----|-----|
| Rust | `gpio-cdev` / `CdevPin` | `i2cdev` / `I2cdev` | `spidev` / `SpidevDevice` |
| C | libgpiod | i2c-tools / libi2c | `spidev_test` |
| Python | `gpiod` | `smbus2` | `spidev` |
| 官方 | wiringOP | — | — |

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 Rust 开发指南]]
- [[RV2 GPIO 与外设]]
- [[调试与测试 MOC]]

## 引用
- linux-embedded-hal：<https://github.com/rust-embedded/linux-embedded-hal>
- gpio-cdev：<https://github.com/rust-embedded/gpio-cdev>
- spidev：<https://crates.io/crates/spidev>
- SPI 用户态 API：<https://docs.kernel.org/spi/spidev.html>
