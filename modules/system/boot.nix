{ config, lib, pkgs, ... }:

{
  # 启动加载器
  boot = {
    loader = {
      grub.enable = false;
      systemd-boot.enable = false;
      refind.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = 3;
    };
    # 内核配置（工作站优化）
    kernelParams = [
      "quiet"
      "splash"
      "amd_pstate=active" # AMD CPU节能（Intel替换为intel_pstate=active）
      "nvme.noacpi=1" # NVMe优化
    ];
    kernelModules = [ "vfio-pci" ]; # 透传（可选）

    tmp.cleanOnBoot = true;
  };

}
