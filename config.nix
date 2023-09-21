{
  company.enable = true;

  themes = {
    name = "catppuccin";
    customEl = ''
      (setq catppuccin-flavor 'mocha)
      (catppuccin-reload)
    '';
  };

  ui = {
    nogui = false;
    menuBar = false;
    toolBar = false;
    scrollBar = false;
  };
}
