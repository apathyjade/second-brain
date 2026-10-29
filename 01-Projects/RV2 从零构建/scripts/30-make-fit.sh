#!/usr/bin/env bash
# 用 mkimage 打包 FIT：boot-bundle.itb（OpenSBI + U-Boot + Linux + dtb）。
set -euo pipefail

OUT="${OUT:-out}"
ITS="${ITS:-configs/boot-bundle.its}"

command -v mkimage >/dev/null 2>&1 || {
	echo "缺少 mkimage（u-boot-tools），无法生成 FIT"
	exit 1
}
[ -f "$ITS" ] || {
	echo "缺少 $ITS"
	exit 1
}

missing=0
for f in Image k1-orangepi-rv2.dtb fw_dynamic.bin u-boot-nodtb.bin u-boot.dtb; do
	if [ ! -f "$OUT/$f" ]; then
		echo "[missing] $OUT/$f"
		missing=1
	fi
done
[ "$missing" -eq 0 ] || {
	echo "请先执行：make opensbi uboot linux"
	exit 1
}

mkimage -f "$ITS" "$OUT/boot-bundle.itb"
echo "[ok] $OUT/boot-bundle.itb"
