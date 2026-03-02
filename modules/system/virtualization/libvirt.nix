{ config, lib, pkgs, ... }:

{
  services.libvirtd = {
    enable = true;
    # 启用TCP监听（可选，用于远程管理）
    listenAddress = "127.0.0.1";
    # 启用DNS/DHCP服务（供虚拟机网络使用）
    virtlogd.enable = true;
  };

  # 启用默认虚拟网络（NAT模式）
  networking.libvirtd.enable = true;
}
