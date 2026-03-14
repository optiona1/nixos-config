{ config, lib, pkgs, username, ... }:

{
  # 主机基础信息（直观）
  networking.hostName = "nixos-workstation";
  system.stateVersion = "25.11";
  time.timeZone = "Asia/Shanghai"; # 替换为你的时区

  # 用户基础配置
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    description = "Main User";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ]; # 按需添加组
    shell = pkgs.fish; # 示例默认shell
  };

  # 主机专属启用/禁用（扩展性：不同主机可覆盖）
  services.printing.enable = false; # 工作站无需打印
  networking.networkmanager.enable = true;
  programs.fish.enable = true;

  # 全局软件包（主机级）
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    helix
  ];

  # 启用sudo免密（可选，提升体验）
  security.sudo.extraRules = [
    {
      users = [ username ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  # 系统服务（工作站专属）
  systemd.services.bluetooth.enable = true;
}
