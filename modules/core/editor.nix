{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types withPlugin;
  cfg = config.core.editor;
in {
  options.core.editor = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the editor configuration.";
    };

    snippets = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable snippet support.";
      };
    };

    completion = {
      enable = mkOption {
        type = types.bool;
        default = true;
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

    syntax = {
      enable = mkOption {
        type = types.bool;
        default = true;
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

    project = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable project management tools.";
      };

      search = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable project-wide search.";
        };
      };
    };

    languages = {
      elixir = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable Elixir support.";
        };

        format = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Elixir formatting support.";
        };

        test = mkOption {
          type = types.bool;
          default = true;
          description = "Enable ExUnit test integration.";
        };
      };

      javascript = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable JavaScript support.";
        };

        prettier = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Prettier formatting.";
        };
      };

      typescript = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable TypeScript support.";
        };

        tide = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Tide TypeScript IDE features.";
        };
      };

      tsx = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable TSX support.";
        };

        prettier = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Prettier formatting for TSX.";
        };
      };

      java = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable Java support.";
        };

        debug = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Java debugging support.";
        };

        format = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Java formatting support.";
        };
      };
    };

    indent = {
      default = mkOption {
        type = types.int;
        default = 2;
        description = "Default indentation width.";
      };

      use_tabs = mkOption {
        type = types.bool;
        default = false;
        description = "Use tabs instead of spaces for indentation.";
      };
    };

    format = {
      on_save = mkOption {
        type = types.bool;
        default = true;
        description = "Enable format on save.";
      };
    };
  };

  config = mkIf cfg.enable {
    elisp = {
      config = ''
        ;; Configurações de completions
        ${
          if cfg.completion.enable
          then ''
            (require 'company)
            (setq company-idle-delay ${toString cfg.completion.company.idle_delay}
                  company-minimum-prefix-length 1)

            ${
              if cfg.completion.company.enable
              then ''
                (require 'company-box)
              ''
              else ""
            }
          ''
          else ""
        }

        ;; Configurações de syntax checking
        ${
          if cfg.syntax.enable
          then ''
            (require 'flycheck)
            (setq flycheck-check-syntax-automatically '(save mode-enabled))

            ${
              if cfg.syntax.flycheck.inline
              then ''
                (require 'flycheck-inline)
              ''
              else ""
            }
          ''
          else ""
        }

        ;; Configurações de projetos
        ${
          if cfg.project.enable
          then ''
            (require 'projectile)
            (setq projectile-completion-system 'ivy)

            ${
              if cfg.project.search.enable
              then ''
                (require 'counsel-projectile)
              ''
              else ""
            }
          ''
          else ""
        }

        ;; Configurações específicas de linguagens
        ${
          if cfg.languages.javascript.enable
          then ''
            (require 'js2-mode)
            (setq js-indent-level ${toString cfg.indent.default})
          ''
          else ""
        }

        ${
          if cfg.languages.typescript.enable
          then ''
            (require 'typescript-mode)
            (setq typescript-indent-level ${toString cfg.indent.default})
          ''
          else ""
        }

        ${
          if cfg.languages.tsx.enable
          then ''
            (require 'web-mode)
            (setq web-mode-code-indent-offset ${toString cfg.indent.default}
                  web-mode-markup-indent-offset ${toString cfg.indent.default}
                  web-mode-css-indent-offset ${toString cfg.indent.default})
          ''
          else ""
        }
      '';

      hook = ''
        ;; Hooks de completions
        ${
          if cfg.completion.enable
          then ''
            (global-company-mode)
            ${
              if cfg.completion.company.enable
              then ''
                (add-hook 'company-mode-hook 'company-box-mode)
              ''
              else ""
            }
          ''
          else ""
        }

        ;; Hooks de syntax checking
        ${
          if cfg.syntax.enable
          then ''
            (global-flycheck-mode)
            ${
              if cfg.syntax.flycheck.inline
              then ''
                (global-flycheck-inline-mode)
              ''
              else ""
            }
          ''
          else ""
        }

        ;; Hooks de projetos
        ${
          if cfg.project.enable
          then ''
            (projectile-mode +1)
            ${
              if cfg.project.search.enable
              then ''
                (counsel-projectile-mode)
              ''
              else ""
            }
          ''
          else ""
        }

        ;; Hooks específicos de linguagens
        ${
          if cfg.languages.elixir.enable
          then ''
            (add-hook 'elixir-mode-hook
                      (lambda ()
                        ${
              if cfg.languages.elixir.format
              then ''
                (add-hook 'before-save-hook 'elixir-format nil t)
              ''
              else ""
            }))

            ${
              if cfg.languages.elixir.test
              then ''
                (add-hook 'elixir-mode-hook 'exunit-mode)
              ''
              else ""
            }
          ''
          else ""
        }

        ${
          if cfg.languages.javascript.enable
          then ''
            (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
            ${
              if cfg.languages.javascript.prettier
              then ''
                (add-hook 'js2-mode-hook 'prettier-js-mode)
              ''
              else ""
            }
          ''
          else ""
        }

        ${
          if cfg.languages.typescript.enable
          then ''
            (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
            ${
              if cfg.languages.typescript.tide
              then ''
                (add-hook 'typescript-mode-hook
                          (lambda ()
                            (tide-setup)
                            (tide-hl-identifier-mode +1)))
              ''
              else ""
            }
          ''
          else ""
        }

        ${
          if cfg.languages.tsx.enable
          then ''
            (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
            ${
              if cfg.languages.tsx.prettier
              then ''
                (add-hook 'web-mode-hook 'prettier-js-mode)
              ''
              else ""
            }
          ''
          else ""
        }
      '';

      bind = ''
        ;; Keybindings de projetos
        ${
          if cfg.project.enable
          then ''
            (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
          ''
          else ""
        }

        ;; Keybindings globais
        (global-set-key (kbd "C-x C-b") 'ibuffer)
        (global-set-key (kbd "M-/") 'hippie-expand)
      '';
    };

    plugins = with pkgs.emacsPackages;
      (withPlugin cfg.snippets.enable [
        yasnippet
        yasnippet-snippets
      ])
      ++ (withPlugin cfg.completion.enable [
        company
        company-box
      ])
      ++ (withPlugin cfg.syntax.enable [
        flycheck
        flycheck-inline
      ])
      ++ (withPlugin cfg.project.enable [
        projectile
        counsel-projectile
      ])
      ++ (withPlugin cfg.languages.elixir.enable
        ([elixir-mode]
          ++ (withPlugin cfg.languages.elixir.test [exunit])))
      ++ (withPlugin cfg.languages.javascript.enable
        ([js2-mode]
          ++ (withPlugin cfg.languages.javascript.prettier [prettier-js])))
      ++ (withPlugin cfg.languages.typescript.enable
        ([typescript-mode]
          ++ (withPlugin cfg.languages.typescript.tide [tide])))
      ++ (withPlugin cfg.languages.tsx.enable
        ([web-mode]
          ++ (withPlugin cfg.languages.tsx.prettier [prettier-js])))
      ++ (withPlugin cfg.languages.java.enable
        [dap-mode]);
  };
}
