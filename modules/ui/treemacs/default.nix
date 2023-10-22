{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugin writeIf;
  cfg = config.ui.treemacs;
in {
  options.ui = {
    treemacs = {
      enable = mkEnableOption {
        description =
          "Treemacs is a file and project explorer similar to NeoTree or vim’s NerdTree";
        type = types.bool;
        default = false;
      };

      lsp = mkOption {
        description = "Enable lsp integration";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages;
      [ treemacs treemacs-nerd-icons treemacs-projectile ]
      ++ (withPlugin cfg.lsp [ lsp-treemacs ])
      ++ (withPlugin config.editor.evil.enable [ treemacs-evil ])
      ++ (withPlugin config.tools.magit.enable [ treemacs-magit ])
      ++ (withPlugin config.ui.workspaces.enable [ treemacs-persp ]);

    extraElisp = {
      bindElisp = ''
        (with-eval-after-load 'winum
          (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
      '';

      configElisp = ''
        (progn
          (setq treemacs-collapse-dirs                  (if treemacs-python-executable 3 0)
               treemacs-deferred-git-apply-delay        0.5
               treemacs-directory-name-transformer      #'identity
               treemacs-display-in-side-window          t
               treemacs-eldoc-display                   'simple
               treemacs-file-event-delay                2000
               treemacs-file-extension-regex            treemacs-last-period-regex-value
               treemacs-file-follow-delay               0.2
               treemacs-file-name-transformer           #'identity
               treemacs-follow-after-init               t
               treemacs-expand-after-init               t
               treemacs-find-workspace-method           'find-for-file-or-pick-first
               treemacs-git-command-pipe                ""
               treemacs-goto-tag-strategy               'refetch-index
               treemacs-header-scroll-indicators        '(nil . "^^^^^^")
               treemacs-hide-dot-git-directory          t
               treemacs-indentation                     2
               treemacs-indentation-string              " "
               treemacs-is-never-other-window           nil
               treemacs-max-git-entries                 5000
               treemacs-missing-project-action          'ask
               treemacs-move-forward-on-expand          nil
               treemacs-no-png-images                   nil
               treemacs-no-delete-other-windows         t
               treemacs-project-follow-cleanup          nil
               treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
               treemacs-position                        'left
               treemacs-read-string-input               'from-child-frame
               treemacs-recenter-distance               0.1
               treemacs-recenter-after-file-follow      nil
               treemacs-recenter-after-tag-follow       nil
               treemacs-recenter-after-project-jump     'always
               treemacs-recenter-after-project-expand   'on-distance
               treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
               treemacs-project-follow-into-home        nil
               treemacs-show-cursor                     nil
               treemacs-show-hidden-files               t
               treemacs-silent-filewatch                nil
               treemacs-silent-refresh                  nil
               treemacs-sorting                         'alphabetic-asc
               treemacs-select-when-already-in-treemacs 'move-back
               treemacs-space-between-root-nodes        t
               treemacs-tag-follow-cleanup              t
               treemacs-tag-follow-delay                1.5
               treemacs-text-scale                      nil
               treemacs-user-mode-line-format           nil
               treemacs-user-header-line-format         nil
               treemacs-wide-toggle-width               70
               treemacs-width                           35
               treemacs-width-increment                 1
               treemacs-width-is-initially-locked       t
               treemacs-workspace-switch-cleanup        nil)
      '';

      initElisp = ''
        (treemacs-follow-mode t)
        (treemacs-filewatch-mode t)
        (treemacs-fringe-indicator-mode 'always)
        (when treemacs-python-executable
          (treemacs-git-commit-diff-mode t))

        (pcase (cons (not (null (executable-find "git")))
                     (not (null treemacs-python-executable)))
          (`(t . t)
            (treemacs-git-mode 'deferred))
          (`(t . _)
            (treemacs-git-mode 'simple)))

        (treemacs-hide-gitignored-files-mode nil))
      '';
    };
  };
}
