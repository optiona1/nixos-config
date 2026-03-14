{ config, lib, pkgs, username, ... }:

{
  home-manager.users.${username} = {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
          cursorline = true;
          auto-format = true;
          idle-timeout = 50;
          bufferline = "multiple";
        };

        # j 键下嵌套 k 键
        keys.insert = {
          j = {
            k = "normal_mode"; 
          };
        };
      };
      languages = {
        language = [{
          name = "python";
          language-servers = ["ruff" "pyright"];
          auto-format = true;
          formatter = { command = "ruff"; args = ["format" "--stdin-filename" "{file}"];};
        }];
        language-server = {
          ruff = {
            command = "ruff";
            args = ["server"];
            config = {
              settings = {
                lineLength = 100;
                lint = {
                  select = ["E4" "E7"];
                  preview = false;
                };
                format = {
                  preview = true;
                };
              };
            };
          };
          pyright = {
            command = "pyright-langserver";
            args = ["--stdio"];

          };
        };
      };
    };
  };
}
