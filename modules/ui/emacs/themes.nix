{ pkgs, ... }:

{
  config = {
    ui.emacs = {
      themes.available = with pkgs.emacsPackages; {
        catppuccin.packages = [ catppuccin-theme ];
        doom-one.packages = [ doom-themes ];
        dracula = {
          packages = [ dracula-theme ];
          supportNoGui = true;
        };
      };
    };
  };
}
