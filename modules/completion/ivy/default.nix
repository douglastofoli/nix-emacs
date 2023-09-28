{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugin writeIf;
  cfg = config.completion.ivy;
in {
  options = {
    completion.ivy = {
      enable = mkEnableOption {
        description = "A generic completion mechanism for Emacs";
        type = types.bool;
        default = false;
      };

      counsel = mkOption {
        description =
          "A collection of Ivy-enhanced versions of common Emacs commands";
        type = types.bool;
        default = false;
      };

      rich = mkOption {
        description = "More friendly interface for ivy";
        type = types.bool;
        default = false;
      };

      swiper = mkOption {
        description = "An Ivy-enhanced alternative to Isearch";
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages;
      [ ivy ] ++ (withPlugin cfg.counsel [ counsel ])
      ++ (withPlugin cfg.rich [ ivy-rich ])
      ++ (withPlugin cfg.swiper [ swiper ]);

    initEl = {
      pre = ''
        (setq ivy-use-virtual-buffers t)
        (setq enable-recursive-minibuffers t)

        ;; Ivy
        (global-set-key (kbd "C-c C-r") 'ivy-resume)
        (global-set-key (kbd "<f6>") 'ivy-resume)

        ;; Swiper
        ${writeIf cfg.swiper ''
          (global-set-key "\C-s" 'swiper)
        ''}
      '';
      main = ''
        ${writeIf cfg.rich ''
          (require 'ivy-rich)
        ''}
      '';
      pos = ''
        (ivy-mode 1)

        ${writeIf cfg.counsel ''
          (counsel-mode 1)
        ''}

        ${writeIf cfg.rich ''
          (ivi-rich-mode 1)
        ''}
      '';
    };
  };
}
