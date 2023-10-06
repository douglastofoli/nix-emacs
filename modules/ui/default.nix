{ config, lib, pkgs, ... }:

let inherit (lib) mkIf mkOption types writeIf;
in {
  imports = [ ./which-key ./nogui.nix ];

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
  };

  config = {
    initEl.pos = ''
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
}
