{
  description = "Nix GNU Emacs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let inherit (flake-utils.lib) eachDefaultSystem mkApp;
    in eachDefaultSystem (system:
      let
        lib = import ./lib.nix;
        inherit (import ./overlays.nix { inherit lib; }) overlays;
        pkgs = import nixpkgs { inherit system overlays; };
        config = import ./config.nix;
      in {
        apps = {
          default = self.outputs.apps.${system}.nix-emacs;
          nix-emacs = mkApp {
            drv = self.outputs.packages.${system}.nix-emacs;
            exePath = "/bin/emacs";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs =
            [ (pkgs.python3.withPackages (ps: with ps; [ PyGithub ])) ];
        };

        packages = {
          default = self.outputs.packages.${system}.nix-emacs;
          nix-emacs = pkgs.callPackage self { inherit config; };
        };

        checks = import ./checks.nix { inherit system; } inputs;
      }) // {
        hmModule = import ./modules/home-manager.nix inputs;
      };
}
