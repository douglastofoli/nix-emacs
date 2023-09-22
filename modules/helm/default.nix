{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption types;
  cfg = config.helm;
in {
  options.helm.enable = mkEnableOption {
    description =
      "Emacs incremental completion and selection narrowing framework";
    type = types.bool;
    default = false;
  };

  config = {
    plugins = with pkgs.emacsPackages; [ helm ];

    initEl = {
      pre = ''
        (global-set-key (kbd "M-x") #'helm-M-x)
        (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
        (global-set-key (kbd "C-x C-f") #'helm-find-files)
      '';
      main = ''
        (require 'helm)
      '';
      pos = ''
        (helm-mode 1)
      '';
    };
  };
}
