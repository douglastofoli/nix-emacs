{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf withPlugin;
  cfg = config.tools.completion;
in {
  options.tools.completion = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable completion support.";
    };

    company = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable company completion.";
      };

      idle_delay = mkOption {
        type = types.float;
        default = 0.1;
        description = "Delay before showing completion suggestions.";
      };
    };
  };

  config = mkIf cfg.enable {
    elisp = {
      init = ''
        (use-package company
          :config
          (global-company-mode)
          (setq company-idle-delay ${toString cfg.company.idle_delay}
                company-minimum-prefix-length 1))

        ${
          if cfg.company.enable
          then ''
            (use-package company-box
              :hook (company-mode . company-box-mode))
          ''
          else ""
        }
      '';
    };

    plugins = with pkgs.emacsPackages;
      [company]
      ++ (withPlugin cfg.company.enable [company-box]);
  };
}
