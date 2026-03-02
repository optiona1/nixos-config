
{ config, lib, pkgs, username, ... }:

{
  # 系统级启用
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-rime
    ];
  };

  # 用户级环境变量（确保生效）
  home-manager.users.${username} = {
    home.sessionVariables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
      GLFW_IM_MODULE = "fcitx";
    };
  };

  # 输入法工具
  environment.systemPackages = with pkgs; [
    fcitx5
    fcitx5-rime
    qt6Packages.fcitx5-configtool
    qt6Packages.fcitx5-chinese-addons
  ];
}
