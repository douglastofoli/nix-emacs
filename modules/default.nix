{ ... }:

{
  imports = [
    ./checkers
    ./completion
    ./editor
    ./emacs

    ./base.nix
    ./warnings.nix
    ./performance
    ./tools
    ./ui
  ];
}
