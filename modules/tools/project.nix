{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf withPlugin;
  cfg = config.tools.project;
in {
  options.tools.project = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable project management tools.";
    };

    search = mkOption {
      type = types.bool;
      default = true;
      description = "Enable project-wide search.";
    };
  };

  config = mkIf cfg.enable {
    elisp = {
      init = ''
        (use-package projectile
          :config
          (projectile-mode +1)
          (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

        ${
          if cfg.search
          then ''
            (use-package counsel-projectile
              :config
              (counsel-projectile-mode))
          ''
          else ""
        }
      '';
    };

    plugins = with pkgs.emacsPackages;
      [projectile]
      ++ (withPlugin cfg.search [counsel-projectile]);
  };
}
