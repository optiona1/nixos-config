
{
  description = "Optimized NixOS Configuration (Single Entry | Intuitive Naming | High Scalability)";

  # 依赖管理（扩展性：新增依赖只需加在这里）
  inputs = {
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    home-manager = {
      #url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/home-manager.git?ref=nixos-25.11&shallow=1";
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      #url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/noctalia-shell.git?ref=nixos-unstable&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, noctalia, ... }@inputs:
    let
      # 全局常量（修改一次，全局生效，提升扩展性）
      system = "x86_64-linux";
      username = "uoong";
      # 多主机配置映射（扩展：新增主机只需加键值对）
      hostConfigs = {
        workstation = import ./hosts/workstation;
        # laptop = import ./hosts/laptop; # 扩展用，取消注释即可
      };
    in
    {
      # 系统配置入口：sudo nixos-rebuild switch --flake .#workstation
      nixosConfigurations = builtins.mapAttrs (hostName: hostModule:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; }; # 传递参数给子模块
          modules = [
            # 硬件配置（按主机名匹配，直观）
            ./hardware/${hostName}.nix
            # 主机专属配置
            hostModule
            # 通用系统模块（可插拔，按需启用）
            ./modules/system/audio.nix
            ./modules/system/boot.nix
            ./modules/system/nix.nix
            ./modules/system/services.nix
            # 桌面相关所有子模块
            ./modules/system/desktop
            # 输入相关所有子模块
            ./modules/system/input
            # 虚拟化
            ./modules/system/virtualization
            # 开发相关模块
            ./modules/dev
            # Shell相关模块
            ./modules/shell

            # Home Manager集成（单一入口管理用户配置）
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs username; };
                useUserPackages = true;
                useGlobalPkgs = true;
                users.${username} = import ./users/${username};
              };
            }
          ];
        }
      ) hostConfigs;

      # 独立Home Manager入口（可选，兼容单独更新用户配置）
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs username; };
        modules = [ ./users/${username} ];
      };
    };
}
