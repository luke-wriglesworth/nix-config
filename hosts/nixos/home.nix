{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  hyprpanel.enable = true;
  hyprland.enable = true;

  imports = [
    inputs.hyprpanel.homeManagerModules.hyprpanel
    inputs.lan-mouse.homeManagerModules.default
    inputs.zen-browser.homeModules.beta
  ];
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

  systemd.user.services.ulauncher = {
    Unit = {
      Description = "Ulauncher service";
      Documentation = "https://ulauncher.io/";
    };
    Service = {
      Type = "simple";
      Restart = "always";
      RestartSec = 1;
      ExecStart = "${pkgs.ulauncher}/bin/ulauncher --hide-window";
    };
    Install = {WantedBy = ["graphical-session.target"];};
  };

  programs.lan-mouse = {
    enable = true;
    systemd = true;
    settings = {
      clients = [
        {
          position = "bottom";
          activate_on_startup = true;
          hostname = "lukes-macbook-pro";
          ips = ["100.115.204.63"];
          port = 4242;
        }
      ];
    };
  };

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [pkgs.firefoxpwa];
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
