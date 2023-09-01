{config, lib, pkgs, ...}:

let 
  inherit (lib) mkIf mkOption types;
in {
    options = {
        nogui = mkOption {
          description = "Use terminal interface instead of GUI";
          type = types.bool;
          default = false;
          };
      };

      config = mkIf config.nogui {
          extraFlags = [ "-nw" ];
        };
  }
