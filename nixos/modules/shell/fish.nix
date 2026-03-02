{ config, lib, pkgs, username, ... }:

{
  # 系统级安装 fish
  environment.systemPackages = with pkgs; [
    fish
    starship
    eza          # ls 替代品
    bat          # cat 替代品
    zoxide       # cd 替代品
    ripgrep      # grep 替代品
    jq           # JSON 处理
    tmux
    lazygit
    delta
    fastfetch
  ];

  # 用户级配置（Home Manager）
  home-manager.users.${username} = {
    programs.fish = {
      enable = true;
      # 自定义配置（直观，易扩展）
    };
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
        };
        git_branch = {
          symbol = "🌱 ";
        };
        package = {
          disabled = true;
        };
      };
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
