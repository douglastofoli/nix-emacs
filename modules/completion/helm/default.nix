{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types;
  cfg = config.completion.helm;
in {
  options = {
    completion.helm.enable = mkEnableOption {
      description =
        "Emacs incremental completion and selection narrowing framework";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages; [ helm ];

    extraElisp = {
      bind = ''
        (global-set-key (kbd "M-x") #'helm-M-x)
        (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
        (global-set-key (kbd "C-x C-f") #'helm-find-files)
      '';

      config = ''
        (require 'helm)
      '';

      init = ''
        (helm-mode 1)
      '';
    };
  };
}
