#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "请使用 sudo 运行：sudo $0"
  exit 1
fi

TARGET_USER="${SUDO_USER:-${USER}}"
TARGET_HOME="$(getent passwd "${TARGET_USER}" | cut -d: -f6)"
REPO_DIR="${REPO_DIR:-$(pwd)}"

if [[ ! -d "${REPO_DIR}/dotfiles/niri" ]]; then
  echo "未找到仓库目录中的 dotfiles/niri，请在仓库根目录运行或设置 REPO_DIR"
  exit 1
fi

CORE_PACKAGES=(
  niri waybar wofi alacritty mako swayidle swaylock
  grim slurp wl-clipboard playerctl brightnessctl
  network-manager-applet blueman thunar pavucontrol
)

OPTIONAL_PACKAGES=(
  fuzzel wlogout swaybg
)

FAILED=()
install_one() {
  local pkg="$1"
  if rpm -q "$pkg" >/dev/null 2>&1; then
    echo "[skip] $pkg 已安装"
    return
  fi

  if zypper --non-interactive install --no-recommends "$pkg"; then
    echo "[ok] $pkg"
  else
    echo "[warn] $pkg 安装失败（可能在仓库中叫其它名字）"
    FAILED+=("$pkg")
  fi
}

echo "==> 刷新仓库"
zypper --non-interactive refresh

echo "==> 安装核心组件"
for pkg in "${CORE_PACKAGES[@]}"; do
  install_one "$pkg"
done

echo "==> 安装可选组件"
for pkg in "${OPTIONAL_PACKAGES[@]}"; do
  install_one "$pkg"
done

echo "==> 写入 Niri 配置"
install -d -m 0755 -o "$TARGET_USER" -g "$TARGET_USER" "$TARGET_HOME/.config/niri"
install -m 0644 -o "$TARGET_USER" -g "$TARGET_USER" \
  "$REPO_DIR/dotfiles/niri/omarchy-tumbleweed.kdl" \
  "$TARGET_HOME/.config/niri/config.kdl"

echo "==> 写入 Waybar 极简配置"
install -d -m 0755 -o "$TARGET_USER" -g "$TARGET_USER" "$TARGET_HOME/.config/waybar"
cat >"$TARGET_HOME/.config/waybar/config" <<'JSON'
{
  "layer": "top",
  "position": "top",
  "height": 30,
  "modules-left": ["niri/workspaces", "clock"],
  "modules-center": ["niri/window"],
  "modules-right": ["pulseaudio", "network", "battery", "tray"],
  "clock": {
    "format": "{:%Y-%m-%d %H:%M}"
  }
}
JSON
chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.config/waybar/config"

if (( ${#FAILED[@]} > 0 )); then
  echo ""
  echo "以下包安装失败，请手动确认包名：${FAILED[*]}"
fi

echo ""
echo "完成。建议执行："
echo "  1) reboot"
echo "  2) 在登录管理器选择 Niri 会话"
echo "  3) Super+Space 打开应用启动器"
