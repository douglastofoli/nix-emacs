{ config, lib, pkgs, ... }:

let inherit (lib) mkOption optional types;
in {
  imports = [ ./loader.nix ./themes.nix ];

  options.ui.emacs = {
    themes = {
      available = mkOption {
        description = "Themes available to select";
        type = types.attrsOf (types.submodule ({ ... }: {
          options = {
            packages = mkOption {
              description = "The themes packages";
              type = types.listOf types.package;
              default = [ ];
            };
            supportNoGui = mkOption {
              description = "Whether the theme supports No Gui mode";
              type = types.bool;
              default = false;
            };
          };
        }));
        default = { };
      };
      name = mkOption {
        description = "Name of the theme to apply to emacs";
        type = types.nullOr types.str;
        default = null;
      };
      customConfig = mkOption {
        description = "Custom elisp to configure your theme";
        type = types.lines;
        default = "";
      };
    };
  };
}
