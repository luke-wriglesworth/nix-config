{
  pkgs,
  lib,
  ...
}: {
  ## Custom Nix Modules ##
  hyprland.enable = true;
  hyprpanel.enable = true;
  lan-mouse.enable = false;
  zen-browser.enable = true;
  ########################

  home.pointerCursor = lib.mkDefault {
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 28;
  };
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Adwaita";
      size = 28;
      package = pkgs.gnome-themes-extra;
    };
  };

  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
      };
    };
  };

  services.cliphist = {
    enable = true;
    allowImages = true;
    systemdTargets = "hyprland-session.target";
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.ghostty}/bin/ghostty";
        layer = "overlay";
        icon-theme = "Papirus-Dark";
        prompt = " ";
      };
      border = {
        radius = "10";
        width = "1";
      };
      dmenu = {
        exit-immediately-if-empty = "yes";
      };
    };
  };
}
