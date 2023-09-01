{ config, lib, pkgs, ... }:

let inherit (lib) mkOption optional types;
in {
  imports = [ ./loader.nix ./themes.nix ];

  options = {
    themes = {
      available = mkOption {
        description = "Themes available to select";
        type = types.attrsOf (types.submodule ({ ... }: {
          options = {
            packages = mkOption {
              description = "Packages required for the theme";
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
        description = "The theme to use";
        type = types.nullOr types.str;
        default = null;
      };
      customEl = mkOption {
        description = "Define custom elisp to configure theme";
        type = types.lines;
        default = "";
      };
    };
  };
}
