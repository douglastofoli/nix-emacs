{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types withPlugin writeIf;
  cfg = config.tools.lsp;
  lang = config.lang;
in {
  options.tools = {
    lsp.enable = mkEnableOption {
      description = "Integrates language servers into Emacs";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages;
      [lsp-mode lsp-ui]
      ++ (withPlugin config.completion.helm.enable [helm-lsp])
      ++ (withPlugin config.completion.ivy.enable [lsp-ivy]);

    extraElisp = {
      config = ''
        (setq lsp-keymap-prefix "s-l")
        (require 'lsp-mode)
      '';

      hook = ''
        ${writeIf (lang.elixir.enable && lang.elixir.lsp) ''
          (add-hook 'elixir-mode #'lsp-deferred)
        ''}
      '';
    };
  };
}
