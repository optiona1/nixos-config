
{ config, lib, pkgs, username, ... }:

{
  # 系统级Neovim
  environment.systemPackages = with pkgs; [
    neovim
    # 依赖工具
    ripgrep
    fd
    tree-sitter
    nodejs # LSP依赖
  ];

  # 用户级Neovim配置（Home Manager）
  home-manager.users.${username}.programs.neovim = {
    enable = true;
    defaultEditor = true;

    # 插件示例（扩展性：按需添加）
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      telescope-nvim
      nvim-lspconfig
      cmp-nvim-lsp
      mason-nvim
      gruvbox-nvim
    ];

    # 基础配置
    extraConfig = ''
      set number relativenumber
      set tabstop=2 shiftwidth=2 expandtab
      set mouse=a
      syntax enable
      colorscheme gruvbox
    '';
  };
}
