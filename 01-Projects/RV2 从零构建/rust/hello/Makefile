# rust/hello —— RV2 交叉编译示例
# 用法：make（或在本目录 cargo build --release）

.PHONY: build run clean deploy

build: ## 交叉编译（依据 .cargo/config.toml 的 target）
	cargo build --release

run: ## 本机运行（需 qemu / 或在板上）
	cargo run --release

clean: ## 清理
	cargo clean

deploy: ## 部署到板子：make deploy RV2_IP=<板子IP>
	scp target/riscv64gc-unknown-linux-gnu/release/rv2-hello "orangepi@$(RV2_IP):~/"
