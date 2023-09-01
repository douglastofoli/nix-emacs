{ config, lib, pkgs, ... }:

{
  config = {
    themes.available = with pkgs.emacsPackages; {
      catppuccin.packages = [ catppuccin-theme ];
      doom-one.packages = [ doom-themes ];
    };
  };
}
