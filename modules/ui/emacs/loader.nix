{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf optional;
  cfg = config.ui.emacs.themes;
in mkIf (cfg.name != null) (let theme = cfg.available.${cfg.name};
in {
  warnings = optional (!theme.supportNoGui && config.ui.nogui)
    "The selected theme does not support No Gui mode";
  plugins = theme.packages;
  initEl.pos = ''
    (load-theme '${cfg.name} :no-confirm)
    ${cfg.customConfig}
  '';
})
