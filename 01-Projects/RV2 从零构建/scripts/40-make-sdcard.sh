#!/usr/bin/env bash
# 生成 SD 卡镜像（优先 genimage）。rootfs.ext4 需由 Buildroot/Yocto 产出。
set -euo pipefail

OUT="${OUT:-out}"

if [ ! -f "$OUT/rootfs.ext4" ]; then
	echo "[warn] 缺少 $OUT/rootfs.ext4（由 Buildroot/Yocto 生成，见 RV2 根文件系统）"
fi

if command -v genimage >/dev/null 2>&1; then
	genimage \
		--rootpath "$OUT" \
		--tmppath genimage-tmp \
		--inputpath "$OUT" \
		--outputpath "$OUT" \
		--config configs/genimage.cfg
	echo "[ok] $OUT/rv2-sdcard.img"
else
	echo "未找到 genimage。可改用 dd + mkfs 手动制作（见 README「SD 镜像」步骤）。"
	exit 1
fi
