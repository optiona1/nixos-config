
{ config, pkgs, ... }: {
  # 基础电源管理
  powerManagement.enable = true;
  
  # 或者使用 powertop 自动优化（笔记本推荐）
  powerManagement.powertop.enable = true;
  services.logind.settings.Login = {
    # 电池供电时合盖：睡眠
    HandleLidSwitch = "suspend";
  
    # 外接电源时合盖：锁定屏幕
    HandleLidSwitchExternalPower = "lock";
  
    # 外接显示器时合盖：忽略（不操作）
    HandleLidSwitchDocked = "ignore";
  
    # 电源按钮行为
    HandlePowerKey = "suspend";        # 短按：睡眠
    HandlePowerKeyLongPress = "poweroff";  # 长按：关机
  };

  # 配置睡眠时间后自动转休眠
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m  # 30分钟后自动转休眠
    SuspendState=mem        # 使用 mem（深度睡眠）而非 s2idle
  '';

  # 设置默认使用 suspend-then-hibernate
  services.logind.settings.Login = {
    LidSwitch = "suspend-then-hibernate";
    PowerKey = "suspend-then-hibernate";
  };
}
