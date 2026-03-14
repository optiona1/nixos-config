{ pkgs, ... }:
{
  keymaps = [
    {
      key = "<leader>p";
      mode = [ "n" ];
      action = "<cmd>YankyRingHistory<CR>";
    }
    {
      key = "<leader>qq";
      mode = [ "n" ];
      action = "<cmd>qa<CR>";
    }
    {
      key = "ge";
      mode = [ "n" ];
      action = "G";
    }
    {
      key = "gl";
      mode = [ "n" ];
      action = "$";
    }
    {
      key = "gs";
      mode = [ "n" ];
      action = "^";
    }
    {
      key = "gh";
      mode = [ "n" ];
      action = "0";
    }
    {
      key = "mm";
      mode = [ "n" ];
      action = "%";
    }
    {
      key = "ge";
      mode = [ "v" ];
      action = "G";
    }
    {
      key = "gl";
      mode = [ "v" ];
      action = "$";
    }
    {
      key = "gs";
      mode = [ "v" ];
      action = "^";
    }
    {
      key = "gh";
      mode = [ "v" ];
      action = "0";
    }
    {
      key = "mm";
      mode = [ "v" ];
      action = "%";
    }
  ];
}
