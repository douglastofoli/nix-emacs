{ config, lib, pkgs, ... }:

let inherit (lib) literalExample mkOption types optional;
in {
  options = {
    extraFlags = mkOption {
      description = "Extra flags to launch the entrypoint";
      type = types.listOf types.str;
      default = [ ];
      example = literalExample " [ \"--\" \"-nw\" ] ";
    };
    identifier = mkOption {
      description = "Unique identifier for the configuration";
      type = types.str;
      default = "default";
    };
    initEl = {
      description = "init.el parts for ordering";
      pre = mkOption {
        description = "init.el pre part for ordering";
        type = types.lines;
        default = "Usually used to configure plugins";
      };
      main = mkOption {
        description = "Usually used to require plugins";
        type = types.lines;
        default = "";
      };
      pos = mkOption {
        description = "Usually used to initialize plugins";
        type = types.lines;
        default = "";
      };
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
      default = [ ];
      example = literalExample "[ pkgs.emacs-evil pkgs.emacs-ivy ]";
    };
    target = mkOption {
      description = "";
      type = types.attrsOf types.package;
      default = { };
      visible = false;
    };
  };
}
