#!/usr/bin/env bash
# 在 RV2 板内（Linux 已启动）把引导固件写入 SPI-NOR。
# ⚠️ 写错分区会变砖：务必先 `cat /proc/mtd` 确认分区，再替换下面的 /dev/mtdX 与文件名。
set -euo pipefail

OUT="${OUT:-out}"

if [ ! -e /proc/mtd ]; then
	echo "本脚本需在 RV2 板内、且内核暴露了 SPI-NOR MTD 分区时运行。"
	exit 1
fi

echo "== 当前 MTD 分区 =="
cat /proc/mtd
echo
echo "参考命令（示例，请按实际分区替换 /dev/mtdX 与文件）："
cat <<'EOF'
  flash_erase /dev/mtd0 0 0 && flashcp out/FSBL.bin         /dev/mtd0
  flash_erase /dev/mtd1 0 0 && flashcp out/fw_dynamic.bin   /dev/mtd1
  flash_erase /dev/mtd2 0 0 && flashcp out/u-boot.itb       /dev/mtd2
EOF
echo
echo "或在 U-Boot 下：sf probe; sf update <ram_addr> <offset> <len>"
echo "已知：RV2 SPI-NOR 型号 XM25QU128C（XMC 128Mb）。"
