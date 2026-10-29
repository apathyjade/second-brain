#!/usr/bin/env bash
# 构建 mainline OpenSBI（generic 平台，生成 fw_dynamic）。
set -euo pipefail

SRC="${SRC:-src}"
OUT="${OUT:-out}"
JOBS="${JOBS:-4}"
CROSS_COMPILE="${CROSS_COMPILE:-riscv64-linux-gnu-}"
D="$SRC/opensbi"

[ -d "$D" ] || {
	echo "缺少 $D，请先执行 make fetch"
	exit 1
}

make -C "$D" CROSS_COMPILE="$CROSS_COMPILE" PLATFORM=generic FW_DYNAMIC=y -j"$JOBS"

mkdir -p "$OUT"
cp "$D/build/platform/generic/firmware/fw_dynamic.bin" "$OUT/"
echo "[ok] $OUT/fw_dynamic.bin"
