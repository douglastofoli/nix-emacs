{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugin writeIf;
  cfg = config.emacs.dired;
in {
  options = {
    emacs.dired = {
      enable = mkEnableOption {
        description =
          "Dired is the main mode for Emacs file-manager operations";
        type = types.bool;
        default = true;
      };

      icons = mkOption {
        description = "Enable icons for Dired";
        type = types.bool;
        default = false;
      };

      ranger = mkOption {
        description = "Enables dired to be more like ranger.";
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages;
      [ diff-hl diredfl dired-rsync fd-dired ]
      ++ (withPlugin cfg.icons [ nerd-icons-dired ])
      ++ (withPlugin cfg.ranger [ dired-ranger ]);

    extraElisp = {
      bind = ''
        (eval-after-load "dired" '(progn
          (define-key dired-mode-map (kbd "C-c C-r") #'dired-rsync)))
      '';

      config = ''
        ${writeIf cfg.icons ''
          (require 'nerd-icons)
          (require 'nerd-icons-dired)
        ''}
      '';

      hook = ''
        ${writeIf cfg.icons ''
          (add-hook 'dired-mode-hook #'nerd-icons-dired-mode)
        ''}
      '';

      init = ''
        (global-diff-hl-mode)
        (diredfl-global-mode)
      '';
    };
  };
}
