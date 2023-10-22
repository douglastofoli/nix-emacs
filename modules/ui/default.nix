{ config, lib, pkgs, ... }:

let inherit (lib) mkIf mkOption types writeIf;
in {
  imports = [
    ./ligatures
    ./themes
    ./treemacs
    ./which-key
    ./workspaces
    ./fonts.nix
    ./nogui.nix
  ];

  options.ui = {
    menuBar = mkOption {
      description = "Show the menu bar";
      type = types.bool;
      default = true;
    };
    toolBar = mkOption {
      description = "Show the tool bar";
      type = types.bool;
      default = true;
    };
    scrollBar = mkOption {
      description = "Show the scroll bar";
      type = types.bool;
      default = true;
    };
    ringBell = mkOption {
      description = "Ring bell";
      type = types.bool;
      default = true;
    };
  };

  config = {
    extraElisp = {
      config = ''
        ${writeIf (!config.ui.ringBell) ''
          (setq ring-bell-function #'ignore
                visible-bell nil)
        ''}
      '';
      init = ''
        ${
          writeIf (!config.ui.menuBar) ''
            (menu-bar-mode -1)
          ''
        } 
        ${writeIf (!config.ui.toolBar) ''
          (tool-bar-mode -1)
        ''}
        ${writeIf (!config.ui.scrollBar) ''
          (scroll-bar-mode -1)
        ''}
      '';
    };
  };
}
