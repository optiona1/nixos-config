
{ config, pkgs, inputs, ... }:
{
  # 启用 niri Wayland 合成器
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  # 依赖包
  environment.systemPackages = with pkgs; [
    niri
    swaylock
    mako
    xwayland-satellite
  ];


  # XWayland 支持
  programs.xwayland.enable = true;
  # 字体
  fonts = {
    packages = with pkgs; [
      # 中文字体
      maple-mono.NF-CN
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "maple mono NF CN" ];
        sansSerif = [ "maple mono NF CN" ];
        monospace = [ "maple mono NF CN" ];
      };
    };
  };

  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
  security.pam.services.swaylock = {};

}
