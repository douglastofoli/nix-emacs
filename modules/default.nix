{...}: {
  imports = [
    ./checkers
    ./completion
    ./editor
    ./emacs
    ./lang

    ./base.nix
    ./warnings.nix
    ./performance
    ./tools
    ./ui
  ];
}
