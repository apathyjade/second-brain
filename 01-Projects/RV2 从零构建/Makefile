# RV2 从零构建 —— 顶层编排
# 详见 RV2 从零构建（工作区）.md
# 本 Makefile 只做编排；实际编译需自备工具链与网络。

# ---- 可覆盖变量 ----
ARCH          ?= riscv
CROSS_COMPILE ?= riscv64-linux-gnu-
SRC           ?= src
OUT           ?= out
JOBS          ?= $(shell (nproc 2>/dev/null) || (sysctl -n hw.ncpu 2>/dev/null) || echo 4)

OPENSBI_REPO  ?= https://github.com/riscv-software-src/opensbi.git
OPENSBI_REF   ?= master
UBOOT_REPO    ?= https://github.com/pyavitz/spacemit-u-boot.git
UBOOT_REF     ?= k1-bl-v2.2.9-release
LINUX_REPO    ?= https://github.com/torvalds/linux.git
LINUX_REF     ?= master

export ARCH
export CROSS_COMPILE
export JOBS

.PHONY: help check fetch opensbi uboot linux fit sdcard spiflash rust clean distclean

help: ## 显示可用目标
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*?## "}{printf "  %-10s %s\n", $$1, $$2}'

check: ## 检查主机工具链与依赖
	@bash scripts/00-check-env.sh

fetch: ## 克隆 OpenSBI / U-Boot / Linux 源码到 $(SRC)
	@bash scripts/10-fetch-sources.sh

opensbi: ## 构建 mainline OpenSBI（fw_dynamic）
	@bash scripts/20-build-opensbi.sh

uboot: ## 构建 U-Boot（K1）
	@bash scripts/21-build-uboot.sh

linux: ## 构建 mainline Linux（Image + dtb）
	@bash scripts/22-build-linux.sh

fit: ## 打包 boot-bundle.itb（FIT）
	@bash scripts/30-make-fit.sh

sdcard: ## 生成 SD 卡镜像（genimage）
	@bash scripts/40-make-sdcard.sh

spiflash: ## 写 SPI-NOR 引导固件（需在板内 / U-Boot 下）
	@bash scripts/90-flash-spinor.sh

rust: ## 交叉编译 rust/hello 示例
	@$(MAKE) -C rust/hello build

clean: ## 清理构建产物（保留克隆的源码）
	@rm -rf $(OUT) rust/hello/target

distclean: clean ## 连同克隆的源码一起清理
	@rm -rf $(SRC)
