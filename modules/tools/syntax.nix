{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf withPlugin;
  cfg = config.tools.syntax;
in {
  options.tools.syntax = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable syntax checking.";
    };

    flycheck = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Flycheck syntax checker.";
      };

      inline = mkOption {
        type = types.bool;
        default = true;
        description = "Enable inline error display.";
      };
    };
  };

  config = mkIf cfg.enable {
    elisp = {
      init = ''
        (use-package flycheck
          :init (global-flycheck-mode)
          :config
          (setq flycheck-check-syntax-automatically '(save mode-enabled)))

        ${
          if cfg.flycheck.inline
          then ''
            (use-package flycheck-inline
              :config
              (global-flycheck-inline-mode))
          ''
          else ""
        }
      '';
    };

    plugins = with pkgs.emacsPackages;
      [flycheck]
      ++ (withPlugin cfg.flycheck.inline [flycheck-inline]);
  };
}
