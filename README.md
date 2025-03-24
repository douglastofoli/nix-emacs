# Nix Emacs

This repository contains a customisable Nix derivation for Emacs.
The expression builds Emacs with all dependencies.

# Quick Start

You can try Nix Emacs by running `nix run github:douglastofoli/nix-emacs`.

# Add to Nix Flake project

You can install nix-emacs in your host by using the nix-emacs package instead the emacs package from NixOs.

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-emacs.url = "github:douglastofoli/nix-emacs";
  };
  
  outputs = {
    self,
    nixpkgs,
    nix-emacs,
    ...
  }: {
    nixosConfigurations.exampleHost = nixpkgs.lib.nixosSystem {
      system  = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      
      modules = [
        let 
          nix-emacs = nix-emacs.packages.${system}.default.override {
            config = {
              package = pkgs.emacs29;
              
              # copy and modify your configuration from `config.nix`
            };
          };
        in
        { 
          services.emacs = {
            enable = true;
            package = nix-emacs;
          };
        }

        # ...
      ];
    };
  };
}
```
