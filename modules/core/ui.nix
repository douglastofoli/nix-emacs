{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types withPlugin;
  cfg = config.core.ui;
in {
  options.core.ui = {
    fonts = {
      default = {
        font = mkOption {
          type = types.str;
          default = "JetBrainsMono Nerd Font";
        };
        height = mkOption {
          type = types.int;
          default = 110;
        };
        weight = mkOption {
          type = types.str;
          default = "medium";
        };
      };

      variablePitch = {
        font = mkOption {
          type = types.str;
          default = "Ubuntu";
        };
        height = mkOption {
          type = types.int;
          default = 110;
        };
        weight = mkOption {
          type = types.str;
          default = "medium";
        };
      };

      fixedPitch = {
        font = mkOption {
          type = types.str;
          default = "JetBrainsMono Nerd Font";
        };
        height = mkOption {
          type = types.int;
          default = 110;
        };
        weight = mkOption {
          type = types.str;
          default = "medium";
        };
      };

      fontLockCommentFace = mkOption {
        type = types.str;
        default = "italic";
      };

      fontLockKeywordFace = mkOption {
        type = types.str;
        default = "italic";
      };

      lineSpacing = mkOption {
        type = types.float;
        default = 0.12;
      };
    };

    themes = {
      name = mkOption {
        type = types.enum ["catppuccin" "doom-one" "dracula"];
        default = "dracula";
        description = "Name of the theme to be used";
      };

      available = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            package = mkOption {
              type = types.package;
              description = "Pacote do tema";
            };
            themeName = mkOption {
              type = types.str;
              description = "Theme name for load-theme";
            };
          };
        });
        default = with pkgs.emacsPackages; {
          catppuccin = {
            package = catppuccin-theme;
            themeName = "catppuccin";
          };
          doom-one = {
            package = doom-themes;
            themeName = "doom-one";
          };
          dracula = {
            package = dracula-theme;
            themeName = "dracula";
          };
        };
      };
    };

    dashboard = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable dashboard on startup";
      };

      items = mkOption {
        type = types.listOf types.str;
        default = [
          "recents"
          "bookmarks"
          "projects"
          "agenda"
        ];
        description = "Items to show in dashboard";
      };

      projectile = mkOption {
        type = types.bool;
        default = true;
        description = "Enable projectile integration in dashboard";
      };

      icons = mkOption {
        type = types.bool;
        default = true;
        description = "Enable icons in dashboard";
      };

      logo = mkOption {
        type = types.enum ["official" "fancy" "logo" "nil"];
        default = "official";
        description = "Logo type to display in dashboard";
      };

      title = mkOption {
        type = types.str;
        default = "Welcome to Emacs!";
        description = "Dashboard title";
      };
    };

    ligatures.enable = mkOption {
      type = types.bool;
      default = true;
    };

    lineNumbers = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable line numbers globally";
      };

      type = mkOption {
        type = types.enum ["relative" "normal"];
        default = "normal";
        description = "Type of line numbers to display";
      };
    };

    nogui = mkOption {
      type = types.bool;
      default = false;
    };

    menuBar = mkOption {
      type = types.bool;
      default = false;
    };

    toolBar = mkOption {
      type = types.bool;
      default = false;
    };

    scrollBar = mkOption {
      type = types.bool;
      default = false;
    };

    ringBell = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    elisp = {
      config = ''
        ;; Basic UI settings
        (setq inhibit-startup-message t)
        (setq visible-bell ${
          if !cfg.ringBell
          then "t"
          else "nil"
        })
        (setq-default line-spacing ${toString cfg.fonts.lineSpacing})

        ;; Font settings
        (setq default-font-settings
              '(:font "${cfg.fonts.default.font}"
                :height ${toString cfg.fonts.default.height}
                :weight ${cfg.fonts.default.weight}))

        (setq variable-pitch-font-settings
              '(:font "${cfg.fonts.variablePitch.font}"
                :height ${toString cfg.fonts.variablePitch.height}
                :weight ${cfg.fonts.variablePitch.weight}))

        (setq fixed-pitch-font-settings
              '(:font "${cfg.fonts.fixedPitch.font}"
                :height ${toString cfg.fonts.fixedPitch.height}
                :weight ${cfg.fonts.fixedPitch.weight}))

        ;; Dashboard settings
        ${
          if cfg.dashboard.enable
          then ''
            (setq dashboard-banner-logo-title "${cfg.dashboard.title}"
                  dashboard-startup-banner '${cfg.dashboard.logo}
                  dashboard-center-content t
                  dashboard-show-shortcuts t
                  dashboard-set-init-info t
                  dashboard-set-footer t
                  dashboard-footer-messages '("Ready to work!")
                  dashboard-items '(
                    ${builtins.concatStringsSep "\n            " (map (item: "(${item} . 5)") cfg.dashboard.items)}
                  )
                  ${
              if cfg.dashboard.projectile
              then "dashboard-projects-backend 'projectile"
              else ""
            }
                  ${
              if cfg.dashboard.icons
              then ''
                dashboard-set-heading-icons t
                dashboard-set-file-icons t
              ''
              else ""
            }
                  inhibit-startup-screen t
                  initial-buffer-choice nil)
          ''
          else ""
        }


        ;; Line number settings
        (setq display-line-numbers-type '${cfg.lineNumbers.type})
      '';

      init = ''
        ;; Load theme
        (load-theme '${cfg.themes.available.${cfg.themes.name}.themeName} t)

        ;; Initialize UI components
        ${
          if !cfg.menuBar
          then "(menu-bar-mode -1)"
          else "(menu-bar-mode 1)"
        }
        ${
          if !cfg.toolBar
          then "(tool-bar-mode -1)"
          else "(tool-bar-mode 1)"
        }
        ${
          if !cfg.scrollBar
          then "(scroll-bar-mode -1)"
          else "(scroll-bar-mode 1)"
        }
        (set-fringe-mode 10)

        ;; Enable line numbers based on configuration
        ${
          if cfg.lineNumbers.enable
          then ''
            (global-display-line-numbers-mode t)
            (column-number-mode)
          ''
          else ""
        }

        ;; Apply font settings
        (set-face-attribute 'default nil
          :font (plist-get default-font-settings :font)
          :height (plist-get default-font-settings :height)
          :weight (plist-get default-font-settings :weight))

        (set-face-attribute 'variable-pitch nil
          :font (plist-get variable-pitch-font-settings :font)
          :height (plist-get variable-pitch-font-settings :height)
          :weight (plist-get variable-pitch-font-settings :weight))

        (set-face-attribute 'fixed-pitch nil
          :font (plist-get fixed-pitch-font-settings :font)
          :height (plist-get fixed-pitch-font-settings :height)
          :weight (plist-get fixed-pitch-font-settings :weight))

        ;; Face attributes
        (set-face-attribute 'font-lock-comment-face nil
          :slant '${cfg.fonts.fontLockCommentFace})
        (set-face-attribute 'font-lock-keyword-face nil
          :slant '${cfg.fonts.fontLockKeywordFace})

        ;; Initialize ligatures
        ${
          if cfg.ligatures.enable
          then ''
            (require 'ligature)
            (ligature-set-ligatures 't '("www"))
            (ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
                                                ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
                                                "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
                                                "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
                                                "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                                                "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
                                                "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
                                                "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                                                "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
                                                "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))
            (global-ligature-mode t)
          ''
          else ""
        }

        ;; Initialize dashboard
        ${
          if cfg.dashboard.enable
          then ''
            (require 'dashboard)
            (dashboard-setup-startup-hook)
          ''
          else ""
        }
      '';

      hook = ''
        ;; Dashboard hooks
        ${
          if cfg.dashboard.enable
          then ''
            (add-hook 'after-init-hook (lambda ()
              (dashboard-refresh-buffer)
              (switch-to-buffer "*dashboard*")))
          ''
          else ""
        }

        ;; Icons hooks
        ${
          if (cfg.dashboard.enable && cfg.dashboard.icons)
          then ''
            (add-hook 'after-init-hook (lambda ()
              (when (display-graphic-p)
                (require 'all-the-icons))))
          ''
          else ""
        }

        ;; Disable line numbers for specific modes
        (dolist (mode '(org-mode-hook
                       term-mode-hook
                       vterm-mode-hook
                       shell-mode-hook
                       eshell-mode-hook))
          (add-hook mode (lambda () (display-line-numbers-mode 0))))
      '';

      bind = ''
        ;; Dashboard keybindings
        ${
          if cfg.dashboard.enable
          then ''
            (global-set-key (kbd "C-c d") 'dashboard-refresh-buffer)
          ''
          else ""
        }
      '';
    };

    plugins = with pkgs.emacsPackages;
      [
        ligature
        cfg.themes.available.${cfg.themes.name}.package
      ]
      ++ (withPlugin cfg.dashboard.enable [dashboard])
      ++ (withPlugin (cfg.dashboard.enable && cfg.dashboard.icons) [all-the-icons]);
  };
}
