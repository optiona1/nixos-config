# Nix 配置（缓存镜像、垃圾回收等）
{ config, lib, ... }: {
  # Nix 设置
  nix.settings = {
    # 启用 flakes
    experimental-features = [ "nix-command" "flakes" ];

    # 缓存镜像配置（按优先级排序）
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"  # 中科大镜像
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"                        # 官方缓存
      "https://nix-community.cachix.org"
    ];

    # 信任的公钥
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    # 自动优化空间
    auto-optimise-store = true;

    # 保持的代数数量（用于垃圾回收）
    keep-outputs = true;
    keep-derivations = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # "beekeeper-studio-5.3.4"
    ];
  };

  # 垃圾回收配置
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
