{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) literalExample mkOption types;
in {
  options = {
    elisp = {
      bind = mkOption {
        description = "Bind elisp";
        type = types.lines;
        default = "";
      };
      config = mkOption {
        description = "Configuration elisp";
        type = types.lines;
        default = "";
      };
      hook = mkOption {
        description = "Hook elisp";
        type = types.lines;
        default = "";
      };
      init = mkOption {
        description = "Initialize elisp";
        type = types.lines;
        default = "";
      };
    };
    extraFlags = mkOption {
      description = "Extra flags to launch the entrypoint";
      type = types.listOf types.str;
      default = [];
      example = literalExample " [ \"--\" \"-nw\" ] ";
    };
    identifier = mkOption {
      description = "Unique identifier for the configuration";
      type = types.str;
      default = "default";
    };
    package = mkOption {
      description = "Emacs package to use";
      type = types.package;
      default = pkgs.emacs;
      example = literalExample "pkgs.emacs";
    };
    plugins = mkOption {
      description = "Emacs plugins to use";
      type = types.listOf types.package;
      default = [];
      example = literalExample "[ pkgs.emacs-evil pkgs.emacs-ivy ]";
    };
    target = mkOption {
      description = "";
      type = types.attrsOf types.package;
      default = {};
      visible = false;
    };
  };
}
