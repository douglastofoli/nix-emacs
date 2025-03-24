{
  emacs-overlay,
  lib,
}: let
  libOverlay = f: p: {
    lib = p.lib.extend (_: _: {inherit (lib) withPlugin writeIf;});
  };
in {overlays = [libOverlay (import emacs-overlay)];}
