{ config, lib, pkgs, username, ... }:

{
  # 导入子模块（如果拆分了libvirt.nix/qemu.nix）
  imports = [
    ./docker.nix
  ];

  # 基础虚拟化支持（KVM/QEMU）
  virtualisation = {
    # 启用libvirt管理工具（含virsh、virt-manager）
    libvirtd.enable = true;
    # 可选：启用virt-manager图形化管理工具
  };
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    dnsmasq
  ];

  # 可选：将当前用户加入libvirt组，无需sudo管理虚拟机
  users.users.${username}.extraGroups = [ "libvirtd" "kvm" ];
}
