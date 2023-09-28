{ config, lib, ... }:

let
  inherit (lib) mkIf mkOption types;
  cfg = config.ui;
in {
  options.ui = {
    nogui = mkOption {
      description = "Use terminal interface instead of GUI";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.nogui { extraFlags = [ "-nw" ]; };
}
