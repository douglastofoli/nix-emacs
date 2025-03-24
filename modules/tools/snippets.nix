{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.tools.snippets;
in {
  options.tools.snippets = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable snippet support.";
    };
  };

  config = mkIf cfg.enable {
    elisp = {
      init = ''
        (use-package yasnippet
          :config
          (yas-global-mode 1))

        (use-package yasnippet-snippets)
      '';
    };

    plugins = with pkgs.emacsPackages; [
      yasnippet
      yasnippet-snippets
    ];
  };
}
