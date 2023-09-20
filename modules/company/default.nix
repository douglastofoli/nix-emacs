{ config, lib, pkgs, ... }:

let inherit (lib) mkEnableOption mkIf;
in {
  options = { company.enable = mkEnableOption "Enable text completion"; };

  config = mkIf config.company.enable {
    plugins = with pkgs.emacsPackages; [ company ];

    initEl = {
      pos = ''
        (add-hook 'after-init-hook 'global-company-mode)
      '';
    };
  };
}
