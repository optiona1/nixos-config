{ config, lib, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  # 引用用户子配置（直观，可插拔）
  imports = [
    ./git.nix
    ./niri.nix
    ./alacritty.nix
  ];

  # 用户级软件包（仅当前用户）
  home.packages = with pkgs; [
    # 日常工具
    fzf
    zoxide
    bat
    eza
    yazi
    # 办公/娱乐
    firefox
    thunderbird
    vlc
  ];

  # 启用Home Manager自动升级
  programs.home-manager.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };
}
