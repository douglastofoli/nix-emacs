{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugin writeIf;
  cfg = config.editor.evil;
in {
  options = {
    editor.evil = {
      enable = mkEnableOption {
        description = "The extensible vi layer for Emacs";
        type = types.bool;
        default = true;
      };

      collection = mkOption {
        description = "A set of keybindings for evil-mode";
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages;
      [ evil ] ++ (withPlugin cfg.collection [ evil-collection ]);

    initEl = {
      pre = ''
        ${writeIf cfg.collection ''
          (setq evil-want-integration t)
          (setq evil-want-keybinding nil)
        ''}
      '';
      main = ''
        (require 'evil)
      '';
      pos = ''
        (evil-mode 1)

        ${writeIf cfg.collection ''
          (evil-collection-init)
        ''}
      '';
    };
  };
}
