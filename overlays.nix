{ lib }:

let
  libOverlay = f: p: { lib = p.lib.extend (_: _: { inherit (lib) writeIf; }); };
in { overlays = [ libOverlay ]; }
