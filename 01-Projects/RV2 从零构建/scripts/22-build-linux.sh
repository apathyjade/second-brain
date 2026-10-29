#!/usr/bin/env bash
# 构建 mainline Linux：产出 Image 与 RV2 板级 dtb。
set -euo pipefail

SRC="${SRC:-src}"
OUT="${OUT:-out}"
JOBS="${JOBS:-4}"
CROSS_COMPILE="${CROSS_COMPILE:-riscv64-linux-gnu-}"
ARCH=riscv
D="$SRC/linux"
FRAG="$(pwd)/configs/linux-k1.fragment"

[ -d "$D" ] || {
	echo "缺少 $D，请先执行 make fetch"
	exit 1
}

make -C "$D" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" defconfig

if [ -f "$FRAG" ]; then
	(
		cd "$D"
		ARCH="$ARCH" scripts/kconfig/merge_config.sh -m .config "$FRAG"
		ARCH="$ARCH" make olddefconfig
	)
fi

make -C "$D" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" -j"$JOBS" Image dtbs

mkdir -p "$OUT"
cp "$D/arch/riscv/boot/Image" "$OUT/"

DTB="$D/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dtb"
if [ -f "$DTB" ]; then
	cp "$DTB" "$OUT/"
	echo "[ok] $OUT/k1-orangepi-rv2.dtb"
else
	echo "[warn] 未找到 $DTB：（mainline 板级 DTS 可能尚未包含 RV2，或符号名不同）请核对 defconfig/片段。"
fi
echo "[ok] $OUT/Image"
