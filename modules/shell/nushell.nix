{ config, lib, pkgs, username, ... }:

{
  # 系统级安装nushell
  environment.systemPackages = with pkgs; [ nushell ];

  # 用户级配置（Home Manager）
  home-manager.users.${username}.programs.nushell = {
    enable = true;
    # 自定义配置（直观，易扩展）
  };
}
