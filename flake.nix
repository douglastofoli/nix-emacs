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

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    emacs-overlay,
    ...
  }: let
    inherit (flake-utils.lib) eachDefaultSystem mkApp;
  in
    eachDefaultSystem (
      system: let
        lib = import ./lib.nix;

        inherit (import ./overlays.nix {inherit emacs-overlay lib;}) overlays;

        pkgs = import nixpkgs {inherit system overlays;};
        config = import ./config.nix {inherit pkgs;};
      in {
        apps = {
          default = self.outputs.apps.${system}.emacs;
          emacs = mkApp {
            drv = self.outputs.packages.${system}.emacs;
            exePath = "/bin/emacs";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [(pkgs.python3.withPackages (ps: with ps; [PyGithub]))];
        };

        packages = {
          default = self.outputs.packages.${system}.emacs;
          emacs = pkgs.callPackage self {inherit config;};
        };
      }
    );
}
