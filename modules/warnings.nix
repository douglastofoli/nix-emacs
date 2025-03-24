{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options = {
    warnings = mkOption {
      description = "Evaluate warnings";
      type = types.listOf types.str;
      default = [];
    };
  };
}
