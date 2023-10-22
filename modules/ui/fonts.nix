{ config, lib, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.ui.fonts;
in {
  options.ui = {
    fonts = {
      default = {
        font = mkOption {
          description = "Font name";
          type = types.str;
          default = "";
        };
        height = mkOption {
          description = "Font size";
          type = types.number;
          default = null;
        };
        weight = mkOption {
          description = "Font weight";
          type = types.str;
          default = "medium";
        };
      };
      variablePitch = {
        font = mkOption {
          description = "Font name";
          type = types.str;
          default = "";
        };
        height = mkOption {
          description = "Font size";
          type = types.number;
          default = null;
        };
        weight = mkOption {
          description = "Font weight";
          type = types.str;
          default = "medium";
        };
      };
      fixedPitch = {
        font = mkOption {
          description = "Font name";
          type = types.str;
          default = "";
        };
        height = mkOption {
          description = "Font size";
          type = types.number;
          default = null;
        };
        weight = mkOption {
          description = "Font weight";
          type = types.str;
          default = "medium";
        };
      };
      fontLockCommentFace = mkOption {
        description = "Font face for commentary";
        type = types.str;
        default = "italic";
      };
      fontLockKeywordFace = mkOption {
        description = "Font face for keywords";
        type = types.str;
        default = "italic";
      };
      lineSpacing = mkOption {
        description = "Define the space between lines";
        type = types.number;
        default = 0.12;
      };
    };
  };

  config = {
    extraElisp.config = ''
      (set-face-attribute 'default nil
        :font "${cfg.default.font}"
        :height ${toString cfg.default.height}
        :weight '${cfg.default.weight})
      (set-face-attribute 'variable-pitch nil
        :font "${cfg.variablePitch.font}"
        :height ${toString cfg.variablePitch.height}
        :weight '${cfg.variablePitch.weight})
      (set-face-attribute 'fixed-pitch nil
        :font "${cfg.fixedPitch.font}"
        :height ${toString cfg.fixedPitch.height}
        :weight '${cfg.fixedPitch.weight})

      (set-face-attribute 'font-lock-comment-face nil
        :slant '${cfg.fontLockCommentFace})
      (set-face-attribute 'font-lock-keyword-face nil
        :slant '${cfg.fontLockKeywordFace})

      (setq-default line-spacing ${toString cfg.lineSpacing})
    '';
  };
}
