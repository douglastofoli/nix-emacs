{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.evil;
in {
  imports = [ ./collection.nix ];

  options.evil = { enable = mkEnableOption "Enable evil-mode"; };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages; [ evil ];

    initEl = {
      main = ''
        (require 'evil)
      '';
      pos = ''
        (evil-mode 1)
      '';
    };
  };
}
