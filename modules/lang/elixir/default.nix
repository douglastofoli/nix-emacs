{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugin writeIf;
  cfg = config.lang.elixir;
in {
  options.lang = {
    elixir = {
      enable = mkEnableOption {
        description = "Provides support for Elixir via elixir-ls";
        type = types.bool;
        default = false;
      };

      lsp = mkOption {
        description = "Enable LSP support for elixir-mode";
        type = types.bool;
        default = false;
      };

      treeSitter = mkOption {
        description = "Uses tree-sitter for better syntax highlighting and structural text editing";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages;
      [elixir-mode exunit]
      ++ (withPlugin config.checkers.syntax.enable [flycheck-credo]);

    extraElisp = {
      hook = ''
        (add-hook 'elixir-mode-hook
                  (lambda () (add-hook 'before-save-hook 'elixir-format nil t)))

        (add-hook 'elixir-format-hook (lambda ()
                                         (if (projectile-project-p)
                                              (setq elixir-format-arguments
                                                    (list "--dot-formatter"
                                                          (concat (locate-dominating-file buffer-file-name ".formatter.exs") ".formatter.exs")))
                                           (setq elixir-format-arguments nil))))

        ${writeIf config.ui.ligatures.enable ''
          (add-hook
            'elixir-mode-hook
            (lambda ()
              (push '(">=" . ?\u2265) prettify-symbols-alist)
              (push '("<=" . ?\u2264) prettify-symbols-alist)
              (push '("!=" . ?\u2260) prettify-symbols-alist)
              (push '("==" . ?\u2A75) prettify-symbols-alist)
              (push '("=~" . ?\u2245) prettify-symbols-alist)
              (push '("<-" . ?\u2190) prettify-symbols-alist)
              (push '("->" . ?\u2192) prettify-symbols-alist)
              (push '("<-" . ?\u2190) prettify-symbols-alist)
              (push '("|>" . ?\u25B7) prettify-symbols-alist)))
        ''}
      '';
    };
  };
}
