{ config, lib, pkgs, username, ... }:

{
  # 系统级安装 fish
  environment.systemPackages = with pkgs; [
    fish
    eza          # ls 替代品
    bat          # cat 替代品
    zoxide       # cd 替代品
    ripgrep      # grep 替代品
    jq           # JSON 处理
    fd
    tmux
    lazygit
    delta
    fastfetch
    dust
  ];

  # 用户级配置（Home Manager）
  home-manager.users.${username} = {
    programs.fish = {
      enable = true;

      # 使用 shellAliases 处理命令替换（更简洁）
      shellAliases = {
        # 现代工具替代（确保下面 packages 中已安装）
        ls = "eza --icons";
        ll = "eza -la --icons";
        lt = "eza --tree --icons";
        la = "eza -a --icons";
        cat = "bat --paging=never";
        find = "fd";
        grep = "rg";
        top = "btop";
        du = "dust";

        n = "nvim";
        vim = "nvim";
        vi = "nvim";
      };
    };
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "bat";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    
    # fzf 配置
    FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border";
    
    # bat 配置
    BAT_THEME = "Dracula";
    
    # eza 配置
    EZA_COLORS = "di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43";
  };
}
