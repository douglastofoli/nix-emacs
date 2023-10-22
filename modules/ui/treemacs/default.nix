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
      config = ''
        (with-eval-after-load 'winum
          (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))

        (with-eval-after-load 'treemacs
          (treemacs-follow-mode t)
          (treemacs-filewatch-mode t)
          (treemacs-fringe-indicator-mode 'always)
          (treemacs-hide-gitignored-files-mode nil))

        ${writeIf config.ui.workspaces.enable ''
          (eval-after-load 'treemacs
            '(eval-after-load 'treemacs-persp
              '(progn
                  (require 'treemacs)
                  (require 'treemacs-persp)
                  (treemacs-set-scope-type 'Perspectives))))
        ''}
      '';
    };
  };
}
