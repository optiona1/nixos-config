{ pkgs, username, ... }:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      registry-mirrors = [ "https://docker.1ms.run" ];
    };
  };

  users.users.${username}.extraGroups = [ "docker" ];
}
