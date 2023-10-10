{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types withPlugin writeIf;
  cfg = config.ui.ligatures;
in {
  options.ui = {
    ligatures.enable = mkEnableOption {
      description = "Display typographical ligatures in Emacs";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages; [ ligature ];

    initEl = {
      pre = ''
        (ligature-set-ligatures 't '("www"))
        (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))

        ;; Enable all Cascadia Code ligatures in programming modes
        (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                             ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                             "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                             "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                             "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                             "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                             "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                             "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                             ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                             "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                             "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                             "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                             "\\\\" "://"))
      '';
      main = ''
        (require 'ligature)
      '';
      pos = ''
        (global-ligature-mode t)
      '';
    };
  };
}
