{pkgs, ...}: {
  package = pkgs.emacs;

  core = {
    editor = {
      enable = true;

      languages = {
        elixir = {
          enable = true;
          format = true;
          test = true;
        };
        javascript = {
          enable = true;
          prettier = true;
        };
        typescript = {
          enable = true;
          tide = true;
        };
        tsx = {
          enable = true;
          prettier = true;
        };
        java = {
          enable = true;
          debug = true;
          format = true;
        };
      };

      completion.enable = true;
      syntax.enable = true;
      project.enable = true;

      indent = {
        default = 2;
        use_tabs = false;
      };

      format.on_save = true;
    };

    ui = {
      fonts = {
        default = {
          font = "JetBrainsMono Nerd Font";
          height = 110;
          weight = "medium";
        };
        variablePitch = {
          font = "Ubuntu";
          height = 110;
          weight = "medium";
        };
        fixedPitch = {
          font = "JetBrainsMono Nerd Font";
          height = 110;
          weight = "medium";
        };
        fontLockCommentFace = "italic";
        fontLockKeywordFace = "italic";
        lineSpacing = 0.12;
      };

      themes.name = "dracula";

      dashboard = {
        enable = true;
        items = [
          "recents"
          "bookmarks"
          "projects"
          "agenda"
        ];
        projectile = true;
        icons = true;
        logo = "official";
        title = "Welcome to Emacs!";
      };

      ligatures.enable = true;

      lineNumbers = {
        enable = true;
        type = "relative";
      };

      nogui = false;
      menuBar = false;
      toolBar = false;
      scrollBar = false;
      ringBell = false;
    };
  };

  lsp = {
    enable = true;
    format.enable = true;
    ui = {
      enable = true;
      sideline = true;
      doc = {
        enable = true;
        delay = 0.3;
      };
    };
  };

  tools = {
    git = {
      enable = true;
      forge = true;
    };
    project.enable = true;
    completion.enable = true;
    syntax.enable = true;
    snippets.enable = true;
  };
}
