# NixOS 配置（系统 / 用户分层重构版）

> 目标：**结构清晰、易扩展、基于 25.11 分支、注释完整**。

本仓库已按职责重构为两条主线：

- `nixos/`：系统级配置（主机、硬件、系统模块）
- `home/`：用户级配置（Home Manager）

这样可以一眼区分“系统做什么”和“用户做什么”。

---

## 1. 版本基线

- `nixpkgs`：`nixos-25.11`
- `home-manager`：`release-25.11`

如需更强复现性，请执行并提交：

```bash
nix flake lock
```

---

## 2. 目录结构（重构后）

```text
nixos-config/
├── flake.nix                     # 唯一入口：统一组装系统层 + 用户层
├── nixos/
│   ├── hardware/                 # 硬件配置（按主机名）
│   │   └── workstation.nix
│   ├── hosts/                    # 主机差异配置（按主机名）
│   │   └── workstation/default.nix
│   └── modules/                  # NixOS 系统模块（纯系统层）
│       ├── core/                 # 核心系统能力（启动/Nix/服务/音频）
│       ├── desktop/              # 桌面环境相关
│       ├── input/                # 输入法/输入设备相关
│       ├── virtualization/       # 虚拟化容器相关
│       ├── development/          # 开发环境（语言/编辑器）
│       └── shell/                # 系统级 shell 配置
├── home/
│   └── users/                    # Home Manager 用户层配置
│       └── uoong/
├── scripts/
│   └── apply-config.sh           # 一键应用脚本
└── README.md
```

---

## 3. 快速使用

```bash
git clone <你的仓库地址> ~/nixos-config
cd ~/nixos-config
```

### 需要替换的内容

1. `flake.nix` 中的 `username`
2. `nixos/hardware/workstation.nix`（从 `/etc/nixos/hardware-configuration.nix` 复制）
3. `scripts/apply-config.sh` 中的路径/主机名/用户名

### 应用配置

```bash
# 推荐：系统 + 用户（通过 NixOS 集成 HM）
./scripts/apply-config.sh

# 备用：仅系统
sudo nixos-rebuild switch --flake .#workstation

# 备用：仅用户
home-manager switch --flake .#yourusername
```

---

## 4. 扩展指南

### 新增主机

1. 新建 `nixos/hardware/<host>.nix`
2. 新建 `nixos/hosts/<host>/default.nix`
3. 在 `flake.nix` 的 `hostModules` 增加 `<host> = import ./nixos/hosts/<host>;`

### 新增用户

1. 新建 `home/users/<user>/default.nix`
2. 在 `flake.nix` 中调整 `username` 或扩展多用户映射

### 新增系统模块

1. 在 `nixos/modules/<domain>/` 新建模块
2. 在 `flake.nix` 的 `nixosCommonModules` 中引入

---

## 5. 设计原则

1. **系统与用户严格分层**：`nixos/` 与 `home/` 分离，减少认知负担。
2. **单一入口**：所有组合逻辑集中在 `flake.nix`，便于审计和演进。
3. **模块化组合**：按领域拆分模块，方便新增/禁用功能。
4. **注释优先**：关键文件保留解释性注释，便于后续维护。


## 6. 快速上手你的开发环境

详细实战步骤见：`docs/DEVELOPMENT_SETUP.md`。


## 7. 软件安装与配置放置规则（速查）

- 放 `nixos/`：系统服务、驱动、容器、全机通用运行时与工具。
- 放 `home/users/`：个人软件、终端/编辑器偏好、Git 身份等。
- 快速判断：**换账号后仍必须存在**的放系统层；仅与你个人习惯相关的放用户层。

详细说明见：`docs/DEVELOPMENT_SETUP.md` 的「3.3 软件安装与配置，应该怎么放？」。
