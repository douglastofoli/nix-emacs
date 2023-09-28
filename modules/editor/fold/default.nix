{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types withPlugin writeIf;
  cfg = config.editor;
in {
  options = {
    editor.fold = {
      enable = mkEnableOption {
        description = "Vim-like text folding for Emacs";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.fold.enable {
    plugins = with pkgs.emacsPackages;
      [ vimish-fold ]
      ++ (withPlugin cfg.evil.enable [ evil-vimish-fold ]);

    initEl = {
      pre = ''
        ${writeIf cfg.evil.enable ''
          (setq evil-vimish-fold-target-modes '(prog-mode conf-mode text-mode))
        ''}
      '';

      main = ''
        (require 'vimish-fold)

        ${writeIf cfg.evil.enable ''
          (require 'evil-vimish-fold)
        ''}
      '';

      pos = ''
        (vimish-fold-global-mode 1)

        ${writeIf cfg.evil.enable ''
          (global-evil-vimish-fold-mode 1)
        ''}
      '';
    };
  };
}
