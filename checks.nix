{ system }:
{ self, nixpkgs, emacs-overlay, ... }@inputs:

let
  inherit (self.outputs.packages.${system}) nix-emacs;
  pkgs = import nixpkgs {
    inherit system;
    overlays = [ (import emacs-overlay) ];
  };

  home-manager = builtins.fetchTarball {
    url =
      "https://github.com/nix-community/home-manager/tarball/c485669ca529e01c1505429fa9017c9a93f15559";
    sha256 = "1zdclkqg1zg06x986q4s03h574djbk8vyrhyqar9yzk61218vmij";
  };
in {
  home-manager-module = (import "${home-manager}/modules" {
    inherit pkgs;
    configuration = {
      imports = [ self.outputs.hmModule ];
      home = {
        username = "nix-emacs";
        homeDirectory = "/tmp";
        stateVersion = "23.05";
      };
      programs.emacs = { enable = true; };
    };
  }).activationPackage;
}
