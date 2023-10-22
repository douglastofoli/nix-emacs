{ config, lib, ... }:

let inherit (lib) mkIf mkOption types;
in {
  options = {
    performance.startup.increase-gc-threshold = mkOption {
      description = "Increase GC threshold to avoid GCs on initialization";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf config.performance.startup.increase-gc-threshold {
    extraElisp.configElisp = ''
      (let (
        (gc-cons-threshold most-positive-fixnum)
        (file-name-handler-alist nil)
      ))
    '';
  };
}
