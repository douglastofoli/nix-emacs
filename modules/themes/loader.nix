{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf optional;
  cfg = config.themes;
in mkIf (cfg.name != null) (let themeName = cfg.available.${cfg.name};
in {
  warnings = optional (!themeName.supportNoGui && config.ui.nogui)
    "The selected theme does not support No Gui mode";
  plugins = themeName.packages;
  initEl.pos = ''
    (load-theme '${cfg.name} :no-confirm)
    ${cfg.customEl}
  '';
})
