#!/usr/bin/env bash
# 构建 U-Boot（K1）。上游 U-Boot 对 K1 仍 WIP，默认使用社区树（可 make UBOOT_REPO=... 覆盖）。
set -euo pipefail

SRC="${SRC:-src}"
OUT="${OUT:-out}"
JOBS="${JOBS:-4}"
CROSS_COMPILE="${CROSS_COMPILE:-riscv64-linux-gnu-}"
ARCH=riscv
D="$SRC/u-boot"

[ -d "$D" ] || {
	echo "缺少 $D，请先执行 make fetch"
	exit 1
}

make -C "$D" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" k1_defconfig
make -C "$D" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" \
	OPENSBI="$PWD/$OUT/fw_dynamic.bin" -j"$JOBS"

mkdir -p "$OUT"
for f in u-boot.itb u-boot-nodtb.bin u-boot.dtb FSBL.bin bootinfo_spinor.bin bootinfo_emmc.bin; do
	if [ -f "$D/$f" ]; then
		cp "$D/$f" "$OUT/"
		echo "[ok] $OUT/$f"
	fi
done
echo "注：产物名随 U-Boot 树不同可能变化，请核对 $D 根目录。"
