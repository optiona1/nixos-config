
{ config, lib, pkgs, username, ... }:

{
  # 系统级Python工具
  environment.systemPackages = with pkgs; [
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.setuptools
    python3Packages.wheel
    python3Packages.ipython
    python3Packages.jupyter
    python3Packages.notebook
    python3Packages.pytest
    python3Packages.black
    python3Packages.isort
    python3Packages.flake8
    python3Packages.mypy
    python3Packages.pylint
    python3Packages.uv
    uv
    ruff
    pyright
  ];

  # 用户级Python配置（Home Manager）
  # home-manager.users.${username} = {
  #   programs.uv = {
  #     enable = true;
  #     settings = {
  #       python.default = "3.12";
  #       cache-dir = "$HOME/.cache/uv";
  #     };
  #   };
  # };
}
