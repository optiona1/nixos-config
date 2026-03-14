# 系统服务配置
{ config, lib, pkgs, ... }: {
  # OpenSSH 服务
  services.openssh = {
    enable = true;
    settings = {
      # 禁用密码登录，仅允许密钥登录
      PasswordAuthentication = true;
      # 允许 root 登录（根据需要调整）
      PermitRootLogin = "no";
      # X11 转发
      X11Forwarding = false;
    };
    # 端口
    ports = [ 22 ];
  };

    # 显示管理器 - greetd + tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --remember --remember-session --cmd niri-session";
        user = "greeter";
      };
    };
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

}
