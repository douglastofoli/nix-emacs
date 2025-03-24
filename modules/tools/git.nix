{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf withPlugin;
  cfg = config.tools.git;
in {
  options.tools.git = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Git integration.";
    };

    gutter = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Git gutter indicators.";
    };

    forge = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Forge for GitHub/GitLab integration.";
    };
  };

  config = mkIf cfg.enable {
    elisp = {
      config = ''
        ;; Magit configurations
        (setq magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)

        ${
          if cfg.gutter
          then ''
            ;; Git-Gutter configurations
            (setq git-gutter:update-interval 2
                  git-gutter:modified-sign "≡"
                  git-gutter:added-sign "+"
                  git-gutter:deleted-sign "-")
          ''
          else ""
        }

        ${
          if cfg.forge
          then ''
            ;; Forge configurations
            (setq forge-database-file (expand-file-name "forge-database.sqlite" user-emacs-directory))
          ''
          else ""
        }
      '';

      init = ''
        ;; Initialize Magit
        (require 'magit)

        ${
          if cfg.gutter
          then ''
            ;; Initialize Git-Gutter
            (require 'git-gutter)
          ''
          else ""
        }

        ${
          if cfg.forge
          then ''
            ;; Initialize Forge
            (require 'forge)
          ''
          else ""
        }
      '';

      hook = ''
        ${
          if cfg.gutter
          then ''
            ;; Enable Git-Gutter globally
            (global-git-gutter-mode +1)
          ''
          else ""
        }

        ;; Refresh Magit status after saving files
        (add-hook 'after-save-hook 'magit-after-save-refresh-status t)
      '';

      bind = ''
        ;; Keybindings for Magit
        (global-set-key (kbd "C-x g") 'magit-status)
        (global-set-key (kbd "C-x M-g") 'magit-dispatch)
        (global-set-key (kbd "C-c M-g") 'magit-file-dispatch)

        ${
          if cfg.gutter
          then ''
            ;; Keybindings for Git-Gutter
            (global-set-key (kbd "C-x C-g") 'git-gutter)
            (global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)
            (global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
            (global-set-key (kbd "C-x n") 'git-gutter:next-hunk)
            (global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)
            (global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)
          ''
          else ""
        }
      '';
    };

    plugins = with pkgs.emacsPackages;
      [magit]
      ++ (withPlugin cfg.gutter [git-gutter])
      ++ (withPlugin cfg.forge [forge]);
  };
}
