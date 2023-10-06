{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugin writeIf;
  cfg = config.ui.which-key;
in {
  options = {
    ui.which-key = {
      enable = mkEnableOption {
        description =
          "Emacs package that displays available keybindings in popup";
        type = types.bool;
        default = true;
      };
      keySeparator = mkOption {
        description = "Set the separator used between keys and descriptions";
        type = types.str;
        default = " → ";
      };
      windowLocation = mkOption {
        description = "Location of which-key window";
        type = types.str;
        default = "botton";
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages; [ which-key ];

    initEl = {
      pre = ''
        (setq which-key-separator "${cfg.keySeparator}")
        (setq which-key-side-window-location '${cfg.windowLocation})
      '';

      main = ''
        (require 'which-key)
      '';

      pos = ''
        (which-key-mode 1)
      '';
    };
  };
}
