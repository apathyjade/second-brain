#!/usr/bin/env bash
# 克隆 OpenSBI / U-Boot / Linux 源码到 $SRC（幂等）。
set -euo pipefail

SRC="${SRC:-src}"
OPENSBI_REPO="${OPENSBI_REPO:-https://github.com/riscv-software-src/opensbi.git}"
OPENSBI_REF="${OPENSBI_REF:-master}"
UBOOT_REPO="${UBOOT_REPO:-https://github.com/pyavitz/spacemit-u-boot.git}"
UBOOT_REF="${UBOOT_REF:-k1-bl-v2.2.9-release}"
LINUX_REPO="${LINUX_REPO:-https://github.com/torvalds/linux.git}"
LINUX_REF="${LINUX_REF:-master}"

clone() { # name repo ref
	local name="$1" repo="$2" ref="$3" dst="$SRC/$name"
	if [ -d "$dst/.git" ]; then
		echo "[skip] $dst 已存在"
		return 0
	fi
	mkdir -p "$SRC"
	echo "[clone] $repo ($ref) -> $dst"
	if ! git clone --depth 1 --branch "$ref" "$repo" "$dst" 2>/dev/null; then
		echo "[warn] 浅克隆指定分支失败，改用完整克隆：$repo"
		git clone "$repo" "$dst"
	fi
}

clone opensbi "$OPENSBI_REPO" "$OPENSBI_REF"
clone u-boot "$UBOOT_REPO" "$UBOOT_REF"
clone linux "$LINUX_REPO" "$LINUX_REF"

echo "完成。源码位于 $SRC/"
