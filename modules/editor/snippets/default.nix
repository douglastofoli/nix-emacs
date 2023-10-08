{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types withPlugin writeIf;
  cfg = config.editor.snippets;
in {
  options.editor = {
    snippets.enable = mkEnableOption {
      description = "Adds snippets expansions to Emacs";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages; [ yasnippet auto-yasnippet ];

    initEl = {
      pre = ''
        (global-set-key (kbd "C-c C-y w")   #'aya-create)
        (global-set-key (kbd "C-c C-y TAB") #'aya-expand)
        (global-set-key (kbd "C-c C-y SPC") #'aya-expand-from-history)
        (global-set-key (kbd "C-c C-y d")   #'aya-delete-from-history)
        (global-set-key (kbd "C-c C-y c")   #'aya-clear-history)
        (global-set-key (kbd "C-c C-y n")   #'aya-next-in-history)
        (global-set-key (kbd "C-c C-y p")   #'aya-previous-in-history)
        (global-set-key (kbd "C-c C-y s")   #'aya-persist-snippet)
        (global-set-key (kbd "C-c C-y o")   #'aya-open-line)
      '';
      main = ''
        (require 'yasnippet)
      '';
      pos = ''
        (yas-global-mode 1)
      '';
    };
  };
}
