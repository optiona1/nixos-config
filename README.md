
# NixOS 优化配置仓库
> 单一入口 | 文件名直观 | 高扩展性

## 核心特性
1. **单一入口**：所有配置通过`flake.nix`驱动，一键脚本`scripts/apply-config.sh`应用
2. **直观命名**：按「硬件/主机/模块/用户」分层，文件名直接对应功能
3. **高扩展性**：支持多主机、多用户、可插拔模块，新增功能只需添加子模块

## 快速使用
### 1. 克隆仓库
```bash
git clone <你的仓库地址> ~/nixos-config
cd ~/nixos-config
```

### 2. 替换占位符
* 修改flake.nix中的username为你的实际用户名
* 修改hardware/workstation.nix为你的硬件配置（从/etc/nixos/hardware-configuration.nix复制）
* 修改scripts/apply-config.sh中的配置项（仓库路径、主机名、用户名）

### 3. 应用配置
```bash
# 一键应用（推荐）
./scripts/apply-config.sh

# 手动应用（备用）
sudo nixos-rebuild switch --flake .#workstation
home-manager switch --flake .#yourusername
```
## 目录结构
```
nixos-config/
├── flake.nix                # 唯一入口：驱动所有配置
├── hardware/                # 硬件配置（按主机区分）
├── hosts/                   # 主机配置（按主机名区分）
├── modules/                 # 通用功能模块（可插拔）
│   ├── system/              # 系统级模块（音频/启动/桌面等）
│   ├── dev/                 # 开发环境模块（语言/编辑器等）
│   └── shell/               # Shell相关模块
├── users/                   # 用户级配置（按用户名区分）
└── scripts/                 # 辅助脚本
```

## 扩展指南
### 新增主机

1. 在hardware/下新增newhost.nix
2. 在hosts/下新增newhost/目录及default.nix
3. 在flake.nix的hostConfigs中添加newhost = import ./hosts/newhost;

### 新增用户
1. 在users/下新增newuser/目录及子配置
2. 在flake.nix中添加users.newuser = import ./users/newuser;

### 新增功能模块
1. 在modules/对应目录下新增xxx.nix
2. 在flake.nix的modules列表中添加引用即可

### 总结
1. **单一入口核心**：`flake.nix` 驱动所有配置，`scripts/apply-config.sh` 一键应用，无需记忆多条命令；
2. **直观命名关键**：按「硬件→主机→模块→用户」分层，文件名直接对应功能（如`fcitx5.nix`=输入法、`python.nix`=Python开发）；
3. **扩展性保障**：新增主机/用户/功能只需添加对应目录/文件，修改`flake.nix`中的映射即可，无需改动核心逻辑。

你只需替换代码中的占位符（如`yourusername`、分区UUID、Git信息等），即可直接使用这套优化后的配置体系。如果需要新增功能（如Docker、Kuber
