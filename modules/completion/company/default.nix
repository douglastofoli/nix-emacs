{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugin writeIf;
  cfg = config.completion.company;
in {
  options.completion = {
    company = {
      enable = mkEnableOption {
        description = "Modular in-buffer completion framework for Emacs";
        type = types.bool;
        default = true;
      };

      childframe = mkOption {
        description =
          "Display completion candidates in a child frame rather than an overlay or tooltip";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages;
      [ company ] ++ (withPlugin cfg.childframe [ company-box ]);

    extraElisp = {
      configElisp = ''
        ${writeIf cfg.childframe ''
          (require 'company-box)
        ''}
      '';

      hookElisp = ''
        (add-hook 'after-init-hook 'global-company-mode)
        ${writeIf cfg.childframe ''
          (add-hook 'company-mode-hook 'company-box-mode)
        ''}
      '';
    };
  };
}
