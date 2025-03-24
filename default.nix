{
  pkgs,
  modules ? [],
  specialArgs ? {},
  ...
} @ args: let
  inherit (pkgs) lib;
  inherit (lib) evalModules;
  inherit (builtins) head length removeAttrs tail trace;
in let
  traceWarnings = warnings: v:
    if length warnings == 0
    then v
    else trace (head warnings) (traceWarnings (tail warnings) v);

  mainModule = removeAttrs args ["pkgs" "specialArgs"];
  input = evalModules {
    modules = [(args: mainModule) ./modules ./target.nix];
    specialArgs = specialArgs // {inherit pkgs;};
  };
in
  traceWarnings input.config.warnings input.config.target.entrypoint
  // {
    inherit input;
    inherit (input) config options;
    inherit (input.config.target) entrypoint;
  }
