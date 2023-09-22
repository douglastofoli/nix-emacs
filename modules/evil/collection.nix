{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  cfg = config.evil;
in {
  options.evil.collection = mkOption {
    description = "A set of keybindings for evil-mode";
    type = types.bool;
    default = true;
  };

  config = mkIf (cfg.enable && cfg.collection) {
    plugins = with pkgs.emacsPackages; [ evil-collection ];

    initEl = {
      pre = ''
        (setq evil-want-integration t)
        (setq evil-want-keybinding nil)
      '';
      main = ''
        (require 'evil-collection nil t)
      '';
      pos = ''
        (evil-collection-init)
      '';
    };
  };
}

