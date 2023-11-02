{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugin writeIf;
  cfg = config.tools.magit;
in {
  options.tools = {
    magit = {
      enable = mkEnableOption {
        description = "It's Magit! A Git Porcelain inside Emacs";
        type = types.bool;
        default = false;
      };

      forge = mkOption {
        description = "Work with Git forges from the comfort of Magit";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages;
      [ magit magit-todos ] ++ (withPlugin cfg.forge [ code-review forge ]);
  };
}
