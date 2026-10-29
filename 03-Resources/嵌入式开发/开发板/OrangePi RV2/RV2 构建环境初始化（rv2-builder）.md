---
title: RV2 构建环境初始化（rv2-builder）
created: "2026-10-19T00:49:20+08:00"
modified: "2026-10-19T00:49:20+08:00"
tags:
  - embedded
  - board
  - build-system
  - yocto
  - reproducible
status: active
area: 嵌入式开发
---

# RV2 构建环境初始化（rv2-builder）

> 上级：[[OrangePi RV2 MOC]] · 相关：[[RV2 系统构建]]、[[RV2 根文件系统]]、[[RV2 工具链与编译]]、[[RV2 从零构建（工作区）]]

> 本文记录 Yocto/kas 构建**容器**（Multipass VM `rv2-builder`）的**初始化内容**：宿主创建参数 → VM 内依赖与配置 → 镜像源策略 → kas 双层配置。目标是**从零可复现**。

## 0. 一句话
macOS 上用 **Multipass 起一台 Ubuntu 24.04 (x86_64) VM 当构建容器**；VM 内装 Yocto 依赖 + `kas`，把 GitHub / 内核源换成国内可达镜像；用「上游层 `orangepi-rv2.yml` + 覆盖层 `ghfast-overlay.yml`」两段 kas 配置构建，产出可烧录 `.wic`。

## 1. 宿主侧（macOS）
| 项 | 值 | 来源 |
|---|---|---|
| 宿主系统 | macOS 26.5.2，**Intel x86_64** | `sw_vers` / `uname -m` |
| 宿主算力 | 16 vCPU / 16 GB RAM | `sysctl` |
| 虚拟化方式 | Multipass（**VM，非 Docker**） | — |
| 容器名 | `rv2-builder` | `multipass list` |
| 容器镜像 | Ubuntu 24.04 LTS（cloud image，**amd64**），image hash `6a81c37564db` | `multipass info` |
| 规格 | 8 vCPU / 8 GB RAM / 100 GB 盘 | `multipass launch` 参数 |
| 实测 qemu 命令行 | `-accel hvf -cpu host -smp 8 -m 8192M -nographic -nic vmnet-shared` | `ps -p <qemu pid>` |

> ⚠️ 宿主是 **Intel(x86_64)**，所以容器是 amd64 + `hvf` 加速。换 Apple Silicon 需改用 arm64 镜像，本笔记的 host 相关设置**不通用**。

创建（复现）：
```bash
multipass launch 24.04 --name rv2-builder --cpus 8 --memory 8G --disk 100G
```

## 2. VM 内初始化（按依赖顺序）

### 2.1 基础依赖（Yocto 必需）
```bash
sudo apt-get update
sudo apt-get install -y gawk wget git diffstat unzip texinfo gcc build-essential \
  chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils \
  iputils-ping python3-git python3-jinja2 python3-subunit zstd liblz4-tool file \
  locales libacl1
```

### 2.2 AppArmor user namespace（**不做这步 bitbake 必失败**）
- **现象**：`bitbake` 起伪终端 / 沙箱时报 user namespace 相关错误。
- **原因**：Ubuntu 24.04 默认 `kernel.apparmor_restrict_unprivileged_userns=1`，限制非特权 user namespace。
- **解决**（临时 + 持久化）：
```bash
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
echo 'kernel.apparmor_restrict_unprivileged_userns=0' | sudo tee /etc/sysctl.d/60-apparmor-userns.conf
```

### 2.3 kas（构建编排器）
```bash
sudo pip3 install --break-system-packages kas    # 实测 kas 5.5
```
> `--break-system-packages` 是绕开 Ubuntu 24.04 的 PEP 668 保护；kas 是独立 CLI，不污染 apt 的 python。

### 2.4 交换空间 & 并行度（防 OOM）
```bash
sudo fallocate -l 15G /swapfile
sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/70-swap.conf
```
- 并行度在覆盖层里降档：`BB_NUMBER_THREADS="6"`、`PARALLEL_MAKE="-j4"`（8 vCPU / 8 GB 下不要拉满）。

### 2.5 网络与镜像源策略（本机环境特有）
容器内 `github.com` **不可达**，故：
```bash
git config --global url."https://ghfast.top/https://github.com/".insteadOf "https://github.com/"
git config --global url."https://ghfast.top/https://raw.githubusercontent.com/".insteadOf "https://raw.githubusercontent.com/"
```
- **实测可达**：`ghfast.top`、`raw.githubusercontent.com`、`codeload.github.com`、`downloads.yoctoproject.org`、`git.yoctoproject.org`、`mirrors.tuna.tsinghua.edu.cn`
- **不可达 / 时通时不通**：`github.com`（不通）、`git.kernel.org`（间歇）

## 3. kas 配置（两层叠加）
调用形如 `kas build A.yml:B.yml`，**后一层覆盖前一层**，原则是「不改上游文件，只叠加」。

### 3.1 上游层 `orangepi-rv2.yml`
- 组装 **poky**（Yocto）+ **meta-riscv**（上游）+ `meta-openembedded`
- 定义 `MACHINE` / `DISTRO` / 目标镜像（`core-image-*`）等

### 3.2 覆盖层 `ghfast-overlay.yml`（本环境关键改动）
| 类别 | 改动 | 目的 |
|---|---|---|
| 下载加速 | `PREMIRRORS:prepend`（走 ghfast） | GitHub 不通时仍能取源 |
| 内核源 | `SRC_URI:pn-linux-mainline = "git://mirrors.tuna.tsinghua.edu.cn/git/linux-stable.git;protocol=https;branch=linux-7.2.y"` | 内核改走 TUNA |
| 内核版本 | `SRCREV` 固定 = `7b20d05fd38de8e0be168956f6fd241d750c7d69`（v7.2.10） | 可复现 |
| 缓存 | `DL_DIR` / `SSTATE_DIR` | 中断后可续跑 |
| 体积 | `INHERIT += "rm_work"` | 省盘（代价：丢中间 work 目录） |
| 并发 | `BB_NUMBER_THREADS="6"` / `PARALLEL_MAKE="-j4"` | 防 OOM |
| 功能 | `ssh-server-openssh` | 便于调试登录 |

> 上表为**会话记录整理**；VM 内**原文**请用 [[#附录 A：导出 VM 内真实配置]] 的命令导出，以原文为准。

## 4. 构建命令与产物
```bash
cd /home/ubuntu/yocto
kas build /home/ubuntu/meta-riscv/kas/orangepi-rv2.yml:/home/ubuntu/meta-riscv/kas/ghfast-overlay.yml 2>&1 | tee ~/kas-build.log
```
- 产物：`~/yocto/build/tmp/deploy/images/orangepi-rv2/*.wic`（+ `.wic.bmap`）
- 取回宿主并校验：
```bash
multipass transfer rv2-builder:/home/ubuntu/yocto/build/tmp/deploy/images/orangepi-rv2/ ./
file *.wic && fdisk -l *.wic
```
- 缓存：`~/yocto/downloads` + `~/yocto/sstate-cache`（约 3 GB，**勿删**，重建靠它续跑）

## 5. 故障记录（2026-10-19）
- **现象**：`multipass` 全部命令报 `cannot connect to the multipass socket`；`multipassd` 空转 ~200% CPU；GUI 卡在 `waiting for daemon`；实例变 `Unknown`（孤儿 qemu 仍在跑）。
- **原因**：`03:45` Multipass 1.16.4 升级后 `multipassd` 被 launchd 重启，**再未创建 `/var/run/multipass_socket`**（launchd socket 激活的 50051 端口也无监听），daemon 卡死在绑定之前。
- **排除项**：`/Library/LaunchDaemons/com.canonical.multipassd.plist` 与随包 `Resources/com.canonical.multipassd.plist` **逐行一致**（曾误判为被改写，已更正）——`Sockets → Listeners → 50051` 是官方标准配置。
- **解决**：需 root 重启 daemon（见附录 B）；恢复后实例可能仍是 `Unknown`，需 `stop --force` + `start`。
- **教训**：daemon 带 `KeepAlive=true`，**卡死时不会自己退出重启**。排查顺序：`ls -l /var/run/multipass_socket` → `lsof -nP -iTCP:50051` → `ps -p <multipassd>`。

## 6. 从零复现（摘要）
1. `multipass launch 24.04 --name rv2-builder --cpus 8 --memory 8G --disk 100G`
2. 2.1 依赖 → 2.2 AppArmor → 2.3 kas → 2.4 swap
3. 2.5 镜像源策略
4. 克隆 `meta-riscv`，写 `orangepi-rv2.yml` 与 `ghfast-overlay.yml`
5. `kas build …` → `multipass transfer` 取 `.wic` → [[RV2 烧录（balenaEtcher）]]

## 附录 A：导出 VM 内真实配置
> 实例恢复 `Running` 后执行，用于回填本笔记「原文」。
```bash
multipass exec rv2-builder -- bash -lc '
  echo "### orangepi-rv2.yml";  cat /home/ubuntu/meta-riscv/kas/orangepi-rv2.yml
  echo "### ghfast-overlay.yml"; cat /home/ubuntu/meta-riscv/kas/ghfast-overlay.yml
  echo "### git insteadOf";     git config --global --get-regexp "url\..*insteadOf"
  echo "### apparmor";          sysctl kernel.apparmor_restrict_unprivileged_userns
  echo "### kas";               kas --version
  echo "### swap";              swapon --show
  echo "### deploy";            ls -la /home/ubuntu/yocto/build/tmp/deploy/images/orangepi-rv2/ 2>/dev/null
'
```

## 附录 B：daemon 卡死时的恢复
```bash
sudo launchctl kickstart -k system/com.canonical.multipassd
# 不行则：
sudo launchctl bootout system/com.canonical.multipassd
sudo launchctl bootstrap system /Library/LaunchDaemons/com.canonical.multipassd.plist
# 再不行：重启 Mac（VM 磁盘与构建缓存都在磁盘上，不会丢）
multipass list
multipass stop --force rv2-builder && multipass start rv2-builder
```

## 相关笔记
- [[OrangePi RV2 MOC]]
- [[RV2 系统构建]]
- [[RV2 根文件系统]]
- [[RV2 工具链与编译]]
- [[RV2 从零构建（工作区）]]
- [[RV2 烧录（balenaEtcher）]]

## 引用
- Multipass：<https://multipass.run>
- kas：<https://github.com/siemens/kas>
- meta-riscv：<https://github.com/riscv/meta-riscv>
- Yocto：<https://www.yoctoproject.org>
- 清华 TUNA 镜像（kernel）：<https://mirrors.tuna.tsinghua.edu.cn/git/linux-stable.git>
