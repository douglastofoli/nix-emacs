{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types writeIf;
  cfg = config.ui.workspaces;
in {
  options.ui = {
    workspaces = {
      enable = mkEnableOption {
        description =
          "Named perspectives(set of buffers/window configs) for emacs ";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages; [ persp-mode ];

    extraElisp = {
      configElisp = ''
        (with-eval-after-load 'persp-mode
          (setq wg-morph-on nil)
          (setq persp-autokill-buffer-on-remove 'kill-weak)) 

        (require 'persp-mode)
      '';

      hookElisp = ''
        (with-eval-after-load 'persp-mode
          (add-hook 'window-setup-hook #'(lambda () (persp-mode 1))))
      '';
    };
  };
}
