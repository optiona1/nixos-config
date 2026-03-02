{ config, lib, pkgs, ... }:

{
  # 替代pulseaudio，现代音频栈
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # 移除pulseaudio避免冲突
  environment.variables = {
    PULSE_SERVER = "unix:/run/user/$(id -u)/pulse/native";
  };
  services.pulseaudio.enable = lib.mkForce false;

  # 音频工具
  environment.systemPackages = with pkgs; [
    alsa-utils
    pamixer
    pipewire
  ];
}
