{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.ui.which-key;
in {
  options.ui = {
    which-key = {
      enable = mkEnableOption {
        description =
          "Emacs package that displays available keybindings in popup";
        type = types.bool;
        default = true;
      };
      separator = mkOption {
        description = "Set the separator used between keys and descriptions";
        type = types.str;
        default = " → ";
      };
      sideWindowLocation = mkOption {
        description = "Location of which-key window";
        type = types.enum [ "top" "bottom" "left" "right" ];
        default = "bottom";
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages; [ which-key ];

    extraElisp = {
      config = ''
        (setq which-key-separator "${cfg.separator}")
        (setq which-key-side-window-location '${cfg.sideWindowLocation})

        (require 'which-key)
      '';

      init = ''
        (which-key-mode 1)
      '';
    };
  };
}
