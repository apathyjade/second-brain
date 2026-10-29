#!/usr/bin/env bash
# 检查构建 RV2 系统所需的主机工具与依赖。只报告，不修改环境。
set -u

ok=0
miss=0
have() { # cmd [hint]
	if command -v "$1" >/dev/null 2>&1; then
		echo "  [ok]   $1"
		ok=$((ok + 1))
	else
		echo "  [MISS] $1${2:+   -> $2}"
		miss=$((miss + 1))
	fi
}

echo "== RV2 构建环境检查 =="

echo "-- 基础工具 --"
have git
have make
have python3

echo "-- 交叉工具链（至少其一）--"
have riscv64-linux-gnu-gcc "apt: gcc-riscv64-linux-gnu"
have clang "LLVM（内核 Rust / 备用）"

echo "-- 固件与镜像工具 --"
have mkimage "u-boot-tools：生成 FIT"
have dtc "device-tree-compiler"
have genimage "生成 SD 镜像（可选，可改用 dd）"
have mkfs.vfat "dosfstools"
have mkfs.ext4 "e2fsprogs"

echo "-- 应用层 --"
have rustup
have cargo

echo "-- 板内烧录（SPI-NOR，需在 RV2 上）--"
have flashcp "mtd-utils"
have flash_erase "mtd-utils"

echo
echo "小结：ok=$ok miss=$miss"
if [ "$miss" -gt 0 ]; then
	echo "提示：缺失项按行内说明安装（macOS: brew；Debian/Ubuntu: apt）。"
fi
exit 0
