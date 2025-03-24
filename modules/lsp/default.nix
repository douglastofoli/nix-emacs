{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf withPlugin;
  cfg = config.lsp;
in {
  options.lsp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable LSP support.";
    };

    format = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable LSP format on save.";
      };
    };

    ui = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable LSP UI enhancements.";
      };

      sideline = mkOption {
        type = types.bool;
        default = true;
        description = "Enable LSP UI sideline.";
      };

      doc = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable LSP UI documentation.";
        };

        delay = mkOption {
          type = types.float;
          default = 0.3;
          description = "Delay in seconds before showing documentation.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    elisp = {
      init = ''
        (use-package lsp-mode
          :commands lsp
          :hook ((prog-mode . lsp))
          :init
          (setq lsp-keymap-prefix "C-c l")
          :config
          (setq lsp-headerline-breadcrumb-enable nil
                lsp-enable-symbol-highlighting t
                lsp-modeline-code-actions-enable t
                lsp-prefer-flymake nil
                lsp-enable-snippet ${
          if config.tools.snippets.enable
          then "t"
          else "nil"
        }
                lsp-enable-on-type-formatting ${
          if cfg.format.enable
          then "t"
          else "nil"
        }
                lsp-enable-indentation ${
          if cfg.format.enable
          then "t"
          else "nil"
        }))

        ${
          if cfg.ui.enable
          then ''
            (use-package lsp-ui
              :commands lsp-ui-mode
              :config
              (setq lsp-ui-doc-enable ${
              if cfg.ui.doc.enable
              then "t"
              else "nil"
            }
                    lsp-ui-doc-delay ${toString cfg.ui.doc.delay}
                    lsp-ui-doc-position 'at-point
                    lsp-ui-sideline-enable ${
              if cfg.ui.sideline
              then "t"
              else "nil"
            }
                    lsp-ui-sideline-show-hover t
                    lsp-ui-sideline-show-diagnostics t))
          ''
          else ""
        }

        ${
          if cfg.format.enable
          then ''
            (add-hook 'before-save-hook
                      (lambda ()
                        (when (and (lsp-session-folders (lsp-session))
                                 (lsp-feature? "textDocument/formatting"))
                          (lsp-format-buffer))))
          ''
          else ""
        }
      '';
    };

    plugins = with pkgs.emacsPackages;
      [lsp-mode]
      ++ (withPlugin cfg.ui.enable [lsp-ui]);
  };
}
