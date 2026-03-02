{ config, lib, pkgs, username, ... }:

{
  programs.git = {
    enable = true;
    # 全局配置（直观，易扩展）
    settings = {
      user = {
        email = "uoong@foxmail.com";
        name = "uoong";
      };
      core = {
        editor = "nvim";
        autocrlf = "input";
        excludesfile = "~/.gitignore_global";
      };
      alias = {
        st = "status";
        ci = "commit";
        br = "branch";
        co = "checkout";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
      pull.rebase = true;
      push.default = "current";

    };


    # 全局忽略文件
    ignores = [
      "*.swp"
      "*.swo"
      "__pycache__"
      "node_modules"
      ".DS_Store"
    ];
  };
}
