{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugin writeIf;
  cfg = config.checkers.syntax;
in {
  options = {
    checkers.syntax = {
      enable = mkEnableOption {
        description = "On the fly syntax checking for GNU Emacs";
        type = types.bool;
        default = true;
      };
      childframe = mkOption {
        description = "Show flycheck errors via posframe.el";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages;
      [ flycheck ] ++ (withPlugin cfg.childframe [ flycheck-posframe ]);

    initEl = {
      main = ''
        (require 'flycheck)

        ${writeIf cfg.childframe ''
          (require 'flycheck-posframe)
        ''}
      '';
      pos = ''
        (global-flycheck-mode)

        ${writeIf cfg.childframe ''
          (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode)
        ''}
      '';
    };
  };
}
