{
  description = "NixOS/Home Manager 配置（按系统与用户清晰分层，基于 25.11）";

  # =========================
  # 1) 依赖输入（全部集中在这里）
  # =========================
  inputs = {
    # 主系统包源：固定在 nixos-25.11 分支。
    # 如需完全可复现，可执行 `nix flake lock` 生成 flake.lock 并提交。
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # 可选：独立引入 unstable，用于极少数需要新版本的软件。
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager 与系统版本保持同一大版本，避免模块接口不匹配。
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 第三方模块示例：noctalia 依赖较新的包，因此跟随 unstable。
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # 第三方应用示例：Zen Browser。
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # =========================
      # 2) 全局常量（单点修改）
      # =========================
      system = "x86_64-linux";
      username = "uoong";

      # 主机模块映射：
      # key = flake 主机名（nixos-rebuild --flake .#<key>）
      # value = 主机入口模块
      hostModules = {
        workstation = import ./nixos/hosts/workstation;
      };

      # 系统级模块组合：只放 NixOS 层，不放用户层。
      nixosCommonModules = [
        ./nixos/modules/core/boot.nix
        ./nixos/modules/core/nix.nix
        ./nixos/modules/core/services.nix
        ./nixos/modules/core/audio.nix
        ./nixos/modules/desktop
        ./nixos/modules/input
        ./nixos/modules/virtualization
        ./nixos/modules/development
        ./nixos/modules/shell
      ];
    in
    {
      # =========================
      # 3) NixOS 系统配置输出
      # =========================
      nixosConfigurations = builtins.mapAttrs
        (hostName: hostModule:
          nixpkgs.lib.nixosSystem {
            inherit system;

            # specialArgs 会传给所有 NixOS 子模块。
            specialArgs = { inherit inputs username; };

            modules =
              [
                # 每台机器的硬件配置（必须与 hostName 对应）
                ./nixos/hardware/${hostName}.nix

                # 主机差异化配置（主机名、网络、用户组等）
                hostModule
              ]
              ++ nixosCommonModules
              ++ [
                # 将 Home Manager 作为 NixOS 子模块接入：
                # 这样 `nixos-rebuild` 时会一并应用用户配置。
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = { inherit inputs username; };
                    users.${username} = import ./home/users/${username};
                  };
                }
              ];
          })
        hostModules;

      # =========================
      # 4) 独立 Home Manager 输出
      # =========================
      # 适用于不切换系统、只切换用户配置场景。
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs username; };
        modules = [ ./home/users/${username} ];
      };
    };
}
