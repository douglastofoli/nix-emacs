{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugin writeIf;
  cfg = config.emacs.undo;
  evil = config.editor.evil;
in {
  options = {
    emacs.undo = {
      enable = mkEnableOption {
        description = "Undo helper with redo";
        type = types.bool;
        default = true;
      };

      tree = mkOption {
        description = "Treat undo history as a tree";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages;
      [ undo-fu undo-fu-session ] ++ (withPlugin cfg.tree [ undo-tree ]);

    extraElisp = {
      configElisp = ''
        (global-unset-key (kbd "C-z"))
        (global-set-key (kbd "C-z")   'undo-fu-only-undo)
        (global-set-key (kbd "C-S-z") 'undo-fu-only-redo)

        (setq undo-limit 67108864) ; 64mb.
        (setq undo-strong-limit 100663296) ; 96mb.
        (setq undo-outer-limit 1006632960) ; 960mb.

        ${writeIf evil.enable ''
          (setq evil-undo-system 'undo-fu)
        ''}

        (require 'undo-tree)
      '';

      initElisp = ''
        (undo-fu-session-global-mode)

        ${writeIf cfg.tree ''
          (global-undo-tree-mode)
        ''}
      '';
    };
  };
}
