# 基于本仓库打造自己的开发环境（NixOS 25.11）

本文给你一个**从 0 到可用**的最短路径：

1. 复制仓库
2. 替换你的主机/用户信息
3. 按需启用开发模块（语言、编辑器、容器等）
4. 一键应用并迭代

---

## 1. 先理解这个仓库怎么分层

- `nixos/`：系统层（NixOS）
  - `hardware/`：硬件信息（磁盘、内核模块等）
  - `hosts/`：主机差异（hostname、用户组、网络）
  - `modules/`：可复用系统模块（桌面、开发、虚拟化、shell）
- `home/users/`：用户层（Home Manager）
  - 用户自己的应用、终端配置、Git 配置等

> 简单记忆：
> - 改“系统能力”去 `nixos/`
> - 改“个人习惯”去 `home/users/`

---

## 2. 初始化你自己的副本

```bash
git clone <your-repo-url> ~/nixos-config
cd ~/nixos-config
```

### 2.1 修改 flake 中用户名

编辑 `flake.nix`：

- 把 `username = "uoong";` 改成你的用户名。

### 2.2 准备你的硬件配置

在你的目标机器上执行：

```bash
sudo nixos-generate-config --show-hardware-config > ./nixos/hardware/workstation.nix
```

如果你是多台机器，建议按机器名复制一份：

- `nixos/hardware/laptop.nix`
- `nixos/hardware/workstation.nix`

并在 `flake.nix` 的 `hostModules` 中添加对应主机。

### 2.3 修改主机配置

编辑 `nixos/hosts/workstation/default.nix`：

- `networking.hostName`
- `time.timeZone`
- `users.users.${username}.extraGroups`

这一步决定“这台机器是什么角色”。

---

## 3. 配置你的开发工具链

### 3.1 系统级（对整台机器生效）

位置：`nixos/modules/development/`

- 编辑器：`editors/neovim.nix`
- 语言：`languages/python.nix`
- 入口：`default.nix`

做法：

1. 新增一个模块文件，例如 `languages/go.nix`
2. 在 `nixos/modules/development/default.nix` 里引入
3. 执行 rebuild

### 3.2 用户级（仅你的账号生效）

位置：`home/users/<yourname>/default.nix`

将你常用工具放进 `home.packages`，例如：

- CLI：`fzf`、`zoxide`、`ripgrep`
- GUI：`firefox`、`thunderbird`

> 推荐策略：
> - 编译器、容器运行时、系统服务放系统层
> - 个人应用和偏好放用户层

---

## 3.3 软件安装与配置，应该怎么放？（强约定）

这是最容易混淆的一点，建议按下面规则执行。

### 放系统层（`nixos/`）的内容

放到系统层，表示“**这台机器**需要它”，与具体用户无关。

典型包括：

- 系统服务：`services.*`（如数据库、打印、SSH、容器服务）
- 驱动与硬件相关：`boot.*`、`hardware.*`
- 系统级程序与运行时：`environment.systemPackages`、容器运行时、编译工具链
- 桌面会话级能力：显示管理器、输入法框架、音频子系统

常用位置：

- `nixos/modules/core/*`：启动、Nix、系统服务
- `nixos/modules/virtualization/*`：docker/libvirt
- `nixos/modules/development/*`：语言运行时、全局开发工具
- `nixos/hosts/<host>/default.nix`：该主机特有的软件与策略

### 放用户层（`home/users/`）的内容

放到用户层，表示“**这个用户**需要它”，通常是个人偏好。

典型包括：

- 用户应用：`home.packages`
- 终端与编辑器个性化：shell aliases、主题、prompt、编辑器插件偏好
- Git 身份：用户名、邮箱、签名策略
- GUI 应用个人习惯：快捷键、配置文件、主题

常用位置：

- `home/users/<user>/default.nix`：用户入口
- `home/users/<user>/git.nix`：Git 配置
- `home/users/<user>/alacritty.nix`：终端配置

### 一句话决策法

- 你换个账号登录后也要有这个软件/能力 → 放 `nixos/`
- 只有你自己想这样用（偏好、主题、账号信息）→ 放 `home/users/`

### 示例对照

- `docker`：系统层（需要系统服务与用户组）
- `git` 程序本体：可系统层或用户层（二选一，建议统一）
- `git user.name/user.email`：用户层
- `python3` 运行时：系统层（团队统一）或用户层（个人实验）
- `neovim` 本体：常放系统层；插件与风格放用户层


## 4. 一键应用与验证

### 4.1 用脚本应用（推荐）

先改 `scripts/apply-config.sh` 三个变量：

- `REPO_DIR`
- `HOST_NAME`
- `USER_NAME`

然后执行：

```bash
./scripts/apply-config.sh
```

### 4.2 手动执行（排障时常用）

```bash
sudo nixos-rebuild switch --flake .#workstation
home-manager switch --flake .#<yourname>
```

---

## 5. 典型日常迭代工作流

```bash
# 1) 修改模块/用户配置
git add -A && git commit -m "feat: update dev env"

# 2) 预览 flake 输出（可选）
nix flake show

# 3) 应用系统
sudo nixos-rebuild switch --flake .#workstation

# 4) 仅调用户配置时
home-manager switch --flake .#<yourname>
```

---

## 6. 常见场景模板

### 场景 A：新增一门语言环境

1. 新建 `nixos/modules/development/languages/<lang>.nix`
2. 在 `nixos/modules/development/default.nix` import
3. rebuild 验证

### 场景 B：新增一台机器

1. 复制 `nixos/hosts/workstation` 为新主机目录
2. 新增 `nixos/hardware/<newhost>.nix`
3. 在 `flake.nix` 的 `hostModules` 注册
4. 用 `.#<newhost>` 构建

### 场景 C：新增一个用户

1. 新建 `home/users/<newuser>/default.nix`
2. 在 `flake.nix` 中切换或扩展用户映射
3. `home-manager switch --flake .#<newuser>`

---

## 7. 稳定性建议（强烈推荐）

1. 提交 `flake.lock`，确保团队复现一致
2. 把“实验性配置”单独拆模块，不污染稳定环境
3. 每次改动后最少执行一次：
   - `sudo nixos-rebuild switch --flake .#<host>`
4. 配合 Git 分支做环境试验，避免直接改主分支

---

## 8. 你可以直接照抄的最小步骤

如果你只想快速跑起来：

1. 改 `flake.nix` 用户名
2. 覆盖 `nixos/hardware/workstation.nix`
3. 改 `nixos/hosts/workstation/default.nix` 的主机名和时区
4. 改 `home/users/<you>/default.nix` 的包列表
5. 执行 `./scripts/apply-config.sh`

完成后，你就拥有了一套“系统层 + 用户层”可持续演进的开发环境。
