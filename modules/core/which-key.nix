{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.core.which-key;
in {
  options.core.which-key = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable which-key mode";
    };

    delay = mkOption {
      type = types.float;
      default = 0.5;
      description = "Delay in seconds before which-key buffer shows up";
    };

    side = mkOption {
      type = types.enum ["bottom" "right" "frame"];
      default = "bottom";
      description = "Which side to display which-key window";
    };

    sort = mkOption {
      type = types.enum ["alphabetical" "length"];
      default = "alphabetical";
      description = "How to sort the which-key buffer";
    };

    custom-prefixes = mkOption {
      type = types.attrsOf types.str;
      default = {
        "C-c p" = "projectile";
        "C-c l" = "lsp";
        "C-c g" = "git";
        "C-x 8" = "unicode";
        "C-c &" = "snippets";
      };
      description = "Custom prefix descriptions";
    };
  };

  config = mkIf cfg.enable {
    elisp = {
      config = ''
        ;; Which-key configuration
        (setq which-key-idle-delay ${toString cfg.delay}  
              which-key-side-window-location '${cfg.side}  
              which-key-sort-order '${if cfg.sort == "alphabetical" then "which-key-key-order-alpha" else "which-key-length-sort"}  
              which-key-add-column-padding 1  
              which-key-max-display-columns nil  
              which-key-min-display-lines 6  
              which-key-separator " → "
              which-key-prefix-prefix "+")

        ;; Custom prefix descriptions
          ${builtins.concatStringsSep "\n" (lib.mapAttrsToList (key: desc: ''  
          (which-key-add-key-based-replacements "${key}" "${desc}")  
        '') cfg.custom-prefixes)}
      '';

      init = ''
        (which-key-mode)
      '';
    };
  };
}