{
  description = "Nix GNU Emacs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    emacs-overlay = { 
      url = "github:nix-community/emacs-overlay"; 
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, emacs-overlay, ... }@inputs:
    let inherit (flake-utils.lib) eachDefaultSystem mkApp;
    in eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs {
          inherit system;
          overlays = [ (import emacs-overlay) ];
        });

        config = {
          company.enable = true;
        };
      in rec {
        apps = rec {
          default = self.outputs.apps.${system}.emacs;
          emacs = mkApp {
            drv = self.outputs.packages.${system}.emacs;
            exePath = "/bin/emacs";
          };
        };

        packages = rec {
          default = self.outputs.packages.${system}.emacs;
          emacs = pkgs.callPackage ./default.nix { inherit config; };
        };

        devShells.default = pkgs.mkShell { packages = [packages.emacs]; };
      });
}
