
#!/usr/bin/env bash
set -euo pipefail

# ===================== 配置项（只需修改这里）=====================
REPO_DIR="$HOME/nixos-config"  # 替换为你的配置仓库路径
HOST_NAME="workstation"        # 替换为你的主机名
USER_NAME="uoong"       # 替换为你的用户名
# ===============================================================

# 切换到配置目录
cd "$REPO_DIR" || { echo "❌ 配置目录不存在：$REPO_DIR"; exit 1; }

echo "🔄 正在更新flake依赖（可选，可注释）..."
nix flake update

echo "🚀 应用系统配置（需要sudo权限）..."
sudo nixos-rebuild switch --flake .#$HOST_NAME

# echo "👤 应用用户配置..."
# home-manager switch --flake .#$USER_NAME
# 注意：用户配置已通过 NixOS 集成的 home-manager 自动应用

echo -e "\n✅ 配置应用完成！主机：$HOST_NAME，用户：$USER_NAME"
