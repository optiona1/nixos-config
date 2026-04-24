# openSUSE Tumbleweed + Niri：Omarchy 风格工作环境

> 目标：借鉴 [basecamp/omarchy](https://github.com/basecamp/omarchy) 的“开箱即用 + 强快捷键 + 极简状态栏”思路，
> 在 openSUSE Tumbleweed 上构建一套日常开发工作环境（不是 1:1 复刻）。

## 设计原则（对齐 Omarchy 思路）

1. **默认可用**：安装后可直接进入平铺工作流。
2. **键盘优先**：核心操作均有快捷键。
3. **组件解耦**：Niri（窗口）+ Waybar（状态）+ Wofi（启动器）+ Mako（通知）。
4. **最小依赖**：优先系统包，减少手工编译。

## 包含内容

- 安装脚本：`scripts/opensuse-tumbleweed-niri-omarchy.sh`
- Niri 预设：`dotfiles/niri/omarchy-tumbleweed.kdl`
- Waybar 极简配置：由脚本写入 `~/.config/waybar/config`

## 一键安装

在仓库根目录执行：

```bash
sudo ./scripts/opensuse-tumbleweed-niri-omarchy.sh
```

## 核心快捷键（默认）

- `Super + Enter`：终端
- `Super + Space`：应用启动器（wofi drun）
- `Super + Shift + Space`：命令启动器（wofi run）
- `Super + H/J/K/L`：聚焦窗口
- `Super + Ctrl + H/J/K/L`：移动窗口
- `Super + Q`：关闭窗口
- `Super + F`：全屏
- `Print`：全屏截图
- `Super + Print`：区域截图
- `Super + Shift + L`：锁屏
- `Super + Shift + E`：退出菜单（wlogout，若未安装请移除该按键）

## 建议的后续优化

1. 在 `~/.config/niri/config.kdl` 里根据显示器调整 `output`。
2. 将 `swaybg` 壁纸路径替换为本地存在文件。
3. 如果 `wofi/wlogout` 在源中不可用，可替换为 `fuzzel` 或 `rofi-wayland`。
4. 配合 `git + helix/neovim + tmux` 可形成更完整开发工作流。

## 说明

- 该方案是 **Omarchy 风格**，不是对上游项目的完整克隆。
- openSUSE 软件包名可能随时间变动；安装脚本会提示失败项并继续。
