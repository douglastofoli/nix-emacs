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

      childframe = mkOption {
        description =
          "Display Ivy windows in a child frame rather than an popup buffer";
        type = types.bool;
        default = false;
      };

      fuzzy = mkOption {
        description = "Enable fuzzy completion for Ivy searches";
        type = types.bool;
        default = false;
      };

      icons = mkOption {
        description =
          "Enable file icons for switch-{buffer,project}/find-file commands";
        type = types.bool;
        default = false;
      };

      prescient = mkOption {
        description = "Enable prescient filtering and sorting for Ivy searches";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages;
      [ amx counsel counsel-projectile ivy ivy-hydra ivy-rich swiper wgrep ]
      ++ (withPlugin cfg.fuzzy [ flx ])
      ++ (withPlugin (cfg.childframe && !config.ui.nogui) [ ivy-posframe ])
      ++ (withPlugin cfg.icons [ nerd-icons-ivy-rich ])
      ++ (withPlugin cfg.prescient [ prescient ]);

    extraElisp = {
      configElisp = ''
        (setq ivy-use-virtual-buffers t
              enable-recusive-minibuffers t)

        (global-set-key "\C-s" 'swiper)
        (global-set-key (kbd "C-c C-r") 'ivy-resume)
        (global-set-key (kbd "<f6>") 'ivy-resume)
        (global-set-key (kbd "M-x") 'counsel-M-x)
        (global-set-key (kbd "C-x C-f") 'counsel-find-file)
        (global-set-key (kbd "<f1> f") 'counsel-describe-function)
        (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
        (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
        (global-set-key (kbd "<f1> l") 'counsel-find-library)
        (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
        (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
        (global-set-key (kbd "C-c g") 'counsel-git)
        (global-set-key (kbd "C-c j") 'counsel-git-grep)
        (global-set-key (kbd "C-c k") 'counsel-ag)
        (global-set-key (kbd "C-x l") 'counsel-locate)
        (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
        (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

        (with-eval-after-load 'ivy
          (setq ivy-initial-inputs-alist nil)

          (ivy-set-display-transformer 'ivy-switch-buffer
                                      'ivy-rich-switch-buffer-transformer))

        (require 'counsel nil t)
      '';

      initElisp = ''
        (ivy-mode)

        (with-eval-after-load 'ivy
          (counsel-mode)
          (ivy-rich-mode 1)
          (nerd-icons-ivy-rich-mode 1)

          (ivy-virtual-abbreviate 'full
          ivy-rich-switch-buffer-align-virtual-buffer t
          ivy-rich-path-style 'abbrev))
      '';
    };
  };
}
