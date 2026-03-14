{ pkgs, lib, ... }:

{
  # 安装办公应用（基于nixpkgs，部分需依赖wine/wayland适配）
  environment.systemPackages = with pkgs; [
    clash-verge-rev
    # wechat
    qq
    feishu
    wemeet
    # beekeeper-studio
    # affine
    audacious
    mpv
    libnotify
        
    #inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # 可选：应用适配配置（如Wayland下微信窗口缩放）
  # environment.variables = {
  #   # 微信Wayland适配
  #   GDK_BACKEND = "wayland,x11";
  #   # 中文字体优先级
  #   FC_FONT_PATH = "${pkgs.noto-fonts-cjk}/share/fonts/truetype";
  # };
}

