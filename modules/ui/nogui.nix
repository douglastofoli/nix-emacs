{ config, lib, pkgs, ... }:

let inherit (lib) mkIf mkOption types;
in {
  options.ui = {
    nogui = mkOption {
      description = "Use terminal interface instead of GUI";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.ui.nogui { extraFlags = [ "-nw" ]; };
}