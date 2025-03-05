{ pkgs, inputs, ... }:

{
    imports = [
                ./home.nix 
                inputs.hyprpanel.homeManagerModules.hyprpanel 
              ];
    home.stateVersion = "24.11";
    home.pointerCursor = {
      gtk.enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 28;
    };
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      cursorTheme = {
        name = "Adwaita";
        size = 28;
        package = pkgs.gnome-themes-extra;
      };
    };

    services.cliphist.enable = true;
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        preload = [ "/home/luke/Pictures/nixos.png" ];
        wallpaper = ["DP-3,/home/luke/Pictures/nixos.png"];
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      settings = {
        "$terminal" = "wezterm";
        "$mod" = "SUPER";

        monitor = [
          "DP-3,2560x1440@164.96,auto,1.0"
        ];

        xwayland = {
          force_zero_scaling = true;
        };

        general = {
          gaps_in = 10;
          gaps_out = 10;
          border_size = 2;
          layout = "dwindle";
          allow_tearing = true;
        };

        input = {
          kb_layout = "us";
          follow_mouse = true;
          touchpad = {
            natural_scroll = true;
          };
          accel_profile = "flat";
          sensitivity = 0.0;
        };

        decoration = {
          rounding = 15;
          active_opacity = 0.9;
          inactive_opacity = 0.8;
          fullscreen_opacity = 0.9;

          blur = {
            enabled = true;
            xray = true;
            special = false;
            new_optimizations = true;
            size = 14;
            passes = 4;
            brightness = 1;
            noise = 0.01;
            contrast = 1;
            popups = true;
            popups_ignorealpha = 0.6;
            ignore_opacity = false;
          };
        };

        animations = {
          enabled = true;
          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92"
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "menu_decel, 0.1, 1, 0, 1"
            "menu_accel, 0.38, 0.04, 1, 0.07"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
            "softAcDecel, 0.26, 0.26, 0.15, 1"
            "md2, 0.4, 0, 0.2, 1"
          ];
          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "windowsIn, 1, 3, md3_decel, popin 60%"
            "windowsOut, 1, 3, md3_accel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 3, md3_decel"
            "layersIn, 1, 3, menu_decel, slide"
            "layersOut, 1, 1.6, menu_accel"
            "fadeLayersIn, 1, 2, menu_decel"
            "fadeLayersOut, 1, 4.5, menu_accel"
            "workspaces, 1, 7, menu_decel, slide"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };

        cursor = {
          enable_hyprcursor = true;
          no_hardware_cursors = 0;
          sync_gsettings_theme = false;
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          smart_split = false;
          smart_resizing = false;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        bind = [
          # General
          "$mod, q, exec, $terminal"
          "$mod, c, killactive"
          "$mod, e, exec, ${pkgs.xfce.thunar}/bin/thunar"
          "$mod, b, exec, zen"
          "$mod SHIFT, e, exit"
          "$mod SHIFT, l, exec, ${pkgs.hyprlock}/bin/hyprlock"

          # Screen focus
          "$mod, v, togglefloating"
          "$mod, u, focusurgentorlast"
          "$mod, tab, focuscurrentorlast"
          "$mod, f, fullscreen"

          # Screen resize
          "$mod CTRL, h, resizeactive, -20 0"
          "$mod CTRL, l, resizeactive, 20 0"
          "$mod CTRL, k, resizeactive, 0 -20"
          "$mod CTRL, j, resizeactive, 0 20"

          # Workspaces
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # Move to workspaces
          "$mod SHIFT, 1, movetoworkspace,1"
          "$mod SHIFT, 2, movetoworkspace,2"
          "$mod SHIFT, 3, movetoworkspace,3"
          "$mod SHIFT, 4, movetoworkspace,4"
          "$mod SHIFT, 5, movetoworkspace,5"
          "$mod SHIFT, 6, movetoworkspace,6"
          "$mod SHIFT, 7, movetoworkspace,7"
          "$mod SHIFT, 8, movetoworkspace,8"
          "$mod SHIFT, 9, movetoworkspace,9"
          "$mod SHIFT, 0, movetoworkspace,10"

          # Navigation
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          # Applications
          "$mod, r, exec, pkill fuzzel || ${pkgs.fuzzel}/bin/fuzzel --launch-prefix='/run/current-system/sw/bin/uwsm app -- '"

          # Clipboard
          "$mod ALT, v, exec, pkill fuzzel || cliphist list | fuzzel --no-fuzzy --dmenu | cliphist decode | wl-copy"

          # Screencapture
          "$mod, S, exec, ${pkgs.grim}/bin/grim | wl-copy"
          "$mod SHIFT+ALT, S, exec, ${pkgs.grim}/bin/grim -g \"$(slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        workspace = [
          "10, border:false, rounding:false, shadow:false, decorate:false"
        ];

        windowrulev2 = [
          "fullscreen,class:^steam_app\\d+$"
          "monitor 1,class:^steam_app_\\d+$"
          "workspace 10,class:^steam_app_\\d+$"
          "tag +opaque, workspace:10"
          "opaque 1, workspace:10, tag:opaque"

        ];

        env = [
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "HYPRCURSOR_THEME,rose-pine-hyprcursor"
          "HYPRCURSOR_SIZE,27"
        ];
        exec-once = [
          # "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
          # "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
          # "eval $(gnome-keyring-daemon --start --components=secrets,ssh,gpg,pkcs11)"
          # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &"
          # "hash dbus-update-activation-environment 2>/dev/null"
          # "export SSH_AUTH_SOCK"
        ];
      };
    };
    programs.waybar = {
      enable = false;
      systemd.enable = true;
      settings = [
        {
          layer = "top";
          position = "top";
          modules-left = ["hyprland/workspaces"];
          modules-center = ["hyprland/window"];
          modules-right = ["custom/notifications" "clock" "tray" "pulseaudio" "custom/lock" "custom/power"];

          "hyprland/workspaces" = {
            disable-scroll = true;
            sort-by-name = false;
            all-outputs = true;
            persistent-workspaces = {
              "Home" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              "5" = [];
              "6" = [];
              "7" = [];
              "8" = [];
              "9" = [];
              "0" = [];
            };
          };

          "tray" = {
            icon-size = 21;
            spacing = 10;
          };

          "clock" = {
            timezone = "Eastern/Toronto";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "  {:%d/%m/%Y}";
            format = "  {:%H:%M}";
          };

          "network" = {
            format-wifi = "{icon} ({signalStrength}%)  ";
            format-ethernet = "{ifname}: {ipaddr}/{cidr} 󰈀 ";
            format-linked = "{ifname} (No IP) 󰌘 ";
            format-disc = "Disconnected 󰟦 ";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };

          "backlight" = {
            device = "intel_backlight";
            format = "{icon}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
          };
          
          "pulseaudio" = {
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = " {volume}%";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "pavucontrol";
          };


          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon}";
            format-charging = "󰂄";
            format-plugged = "󱟢";
            format-alt = "{icon}";
            format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          };

          ## https://github.com/Frost-Phoenix/nixos-config/blob/4d75ca005a820672a43db9db66949bd33f8fbe9c/modules/home/waybar/settings.nix#L116
          "custom/notifications" = {
            tooltip = false;
            format = "{icon} Notifications";
            format-icons = {
              notification = "󱥁 <span foreground='red'><sup></sup></span>";
              none = "󰍥 ";
              dnd-notification = "󱙍 <span foreground='red'><sup></sup></span>";
              dnd-none = "󱙎 ";
              inhibited-notification = "󱥁 <span foreground='red'><sup></sup></span>";
              inhibited-none = "󰍥 ";
              dnd-inhibited-notification = "󱙍 <span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "󱙎 ";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };
          

          "custom/lock" = {
            tooltip = false;
            on-click = "${pkgs.hyprlock}/bin/hyprlock";
            format = " ";
          };

          "custom/power" = {
            tooltip = false;
            on-click = "${pkgs.wlogout}/bin/wlogout &";
            format = " ";
          };
        }
      ];

      style = ''
        * {
          font-family: 'Ubuntu Nerd Font';
          font-size: 13px;
          min-height: 0;
        }

        #waybar {
          background: transparent;
          color: @text;
          margin: 5px 5px;
        }

        #workspaces {
          border-radius: 1rem;
          margin: 5px;
          background-color: @surface0;
          margin-left: 1rem;
        }

        #workspaces button {
          color: @lavender;
          border-radius: 1rem;
          padding: 0.4rem;
        }

        #workspaces button.active {
          color: @peach;
          border-radius: 1rem;
        }

        #workspaces button:hover {
          color: @peach;
          border-radius: 1rem;
        }

        #custom-music,
        #tray,
        #backlight,
        #network,
        #clock,
        #battery,
        #custom-lock,
        #custom-notifications,
        #custom-power {
          background-color: @surface0;
          padding: 0.5rem 1rem;
          margin: 5px 0;
        }

        #clock {
          color: @blue;
          border-radius: 1rem 1rem 1rem 1rem;
          margin-right: 1rem;
        }

        #pulseaudio {
          color: @blue;
          border-radius: 1rem 1rem 1rem 1rem;
          margin-right: 1rem;
        }

        #battery {
          color: @green;
        }

        #custom-notifications {
          border-radius: 1rem;
          margin-right: 1rem;
          color: @peach;
        }

        #custom-music {
          color: @mauve;
          border-radius: 1rem;
        }

        #custom-lock {
            border-radius: 1rem 0px 0px 1rem;
            color: @lavender;
        }

        #custom-power {
            margin-right: 1rem;
            border-radius: 0px 1rem 1rem 0px;
            color: @red;
        }

        #tray {
          margin-right: 1rem;
          border-radius: 1rem;
        }

        @define-color rosewater #f4dbd6;
        @define-color flamingo #f0c6c6;
        @define-color pink #f5bde6;
        @define-color mauve #c6a0f6;
        @define-color red #ed8796;
        @define-color maroon #ee99a0;
        @define-color peach #f5a97f;
        @define-color yellow #eed49f;
        @define-color green #a6da95;
        @define-color teal #8bd5ca;
        @define-color sky #91d7e3;
        @define-color sapphire #7dc4e4;
        @define-color blue #8aadf4;
        @define-color lavender #b7bdf8;
        @define-color text #cad3f5;
        @define-color subtext1 #b8c0e0;
        @define-color subtext0 #a5adcb;
        @define-color overlay2 #939ab7;
        @define-color overlay1 #8087a2;
        @define-color overlay0 #6e738d;
        @define-color surface2 #5b6078;
        @define-color surface1 #494d64;
        @define-color surface0 #363a4f;
        @define-color base #24273a;
        @define-color mantle #1e2030;
        @define-color crust #181926;
      '';
    };
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "${pkgs.ghostty}/bin/ghostty";
          layer = "overlay";
          icon-theme = "Papirus-Dark";
          prompt = " ";
          font = "UbuntuMono Nerd Font";
        };
        colors = {
          background = "24273add";
          text = "cad3f5ff";
          selection = "5b6078ff";
          selection-text = "cad3f5ff";
          border = "b7bdf8ff";
          match = "ed8796ff";
          selection-match = "ed8796ff";
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
  programs.hyprpanel = {

    # Enable the module.
    # Default: false
    enable = true;
    overlay.enable = true;

    # Automatically restart HyprPanel with systemd.
    # Useful when updating your config so that you
    # don't need to manually restart it.
    # Default: false

    # Add '/nix/store/.../hyprpanel' to your
    # Hyprland config 'exec-once'.
    # Default: false
    hyprland.enable = true;

    # Fix the overwrite issue with HyprPanel.
    # See below for more information.
    # Default: false
    overwrite.enable = true;

    # Import a theme from './themes/*.json'.
    # Default: ""
    theme = "gruvbox";

    # Configure bar layouts for monitors.
    # See 'https://hyprpanel.com/configuration/panel.html'.
    # Default: null
    layout = {
      "bar.layouts" = {
        "0" = {
          left = [ "dashboard" "workspaces" "windowtitle"];
          middle = [ "media" "cava"];
          right = [ "volume"  "cpu" "ram" "systray" "bluetooth" "clock" "notifications" ];
        };
      };
    };
     

    # Configure and theme almost all options from the GUI.
    # Options that require '{}' or '[]' are not yet implemented,
    # except for the layout above.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;
      bar.workspaces.show_numbered = true;
      bar.workspaces.workspaces = 10;
      bar.workspaces.numbered_active_indicator = "underline";

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = false;
      menus.dashboard.shortcuts.enabled = false;

      theme.bar = {
        transparent = false;
        scaling = 80;
        outer_spacing = "1.0em";
      };

      # theme.font = {
      #   name = "CaskaydiaCove NF";
      #   size = "16px";
      # };
    };
  };
}
