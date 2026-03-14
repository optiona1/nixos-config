{ config, lib, pkgs, username, ... }:

{
  # 系统级启用
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        rime-data
        qt6Packages.fcitx5-chinese-addons
        fcitx5-rime
        fcitx5-gtk
      ];
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "rime";
        };
        "Groups/0/Items/0" = {
          Name = "keyboard-us";  # 英文键盘
        };
        "Groups/0/Items/1" = {
          Name = "rime";         # 中州韵（Rime）
        };
      };
    };
  };

  # 用户级环境变量（确保生效）
  home-manager.users.${username} = {
    home.sessionVariables = {
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
      GLFW_IM_MODULE = "fcitx";
    };
  };
}
