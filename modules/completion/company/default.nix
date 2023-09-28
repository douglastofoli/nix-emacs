{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types;
  cfg = config.completion.company;
in {
  options = {
    completion.company.enable = mkEnableOption {
      description = "Modular in-buffer completion framework for Emacs";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages; [ company ];

    initEl = {
      pos = ''
        (add-hook 'after-init-hook 'global-company-mode)
      '';
    };
  };
}
