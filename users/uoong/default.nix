{ config, lib, pkgs, inputs, username, ... }:

let
  dotfiles = "${config.home.homeDirectory}/config/dotfiles";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory
  configs = {
    # nvim = "nvim";
    alacritty = "alacritty";
    niri = "niri";
  };
  dataConfigs = {
    "fcitx5/rime" = "rime";
  };
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  # 引用用户子配置（直观，可插拔）
  imports = [
    ./git.nix
    ./swayidle.nix
    inputs.nixvim.homeModules.nixvim
  ];
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  xdg.dataFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
    })
    dataConfigs;

  # 用户级软件包（仅当前用户）
  home.packages = with pkgs; [
    # 日常工具
    fzf
    zoxide
    bat
    eza
    yazi
    tre
    # 办公/娱乐
    firefox
    thunderbird
    vlc
    alacritty
  ];

  # 启用Home Manager自动升级
  programs.home-manager.enable = true;
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };
}
