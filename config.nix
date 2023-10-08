{ pkgs, ... }:

{
  package = pkgs.emacs29;

  checkers = {
    syntax = {

      enable = true;
      childframe = true;

    };
  };

  completion = {
    company.enable = true;
    helm.enable = false;
    ivy = {
      enable = true;
      counsel = true;
      rich = true;
      swiper = true;
    };
  };

  editor = {
    evil = {
      enable = true;
      collection = true;
    };
    fold.enable = true;
    snippets.enable = true;
  };

  themes = { name = "dracula"; };

  ui = {
    nogui = false;
    menuBar = false;
    toolBar = false;
    scrollBar = false;

    ringBell = false;

    which-key = {
      enable = true;
      keySeparator = " → ";
      windowLocation = "bottom";
    };
  };
}
