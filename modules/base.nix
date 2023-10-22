{ config, lib, pkgs, ... }:

let inherit (lib) literalExample mkOption types optional;
in {
  options = {
    extraElisp = {
      bindElisp = mkOption {
        description = "Bind elisp";
        type = types.lines;
        default = "";
      };
      configElisp = mkOption {
        description = "Configuration elisp";
        type = types.lines;
        default = "";
      };
      hookElisp = mkOption {
        description = "Hook elisp";
        type = types.lines;
        default = "";
      };
      initElisp = mkOption {
        description = "Initialize elisp";
        type = types.lines;
        default = "";
      };
      pre = mkOption {
        description = "init.el pre part for ordering";
        type = types.lines;
        default = "";
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
