{
  config,
  lib,
  pkgs,
  ...
}: {
  options.hyprland.enable = lib.mkEnableOption "Enables Hyprland configuration";
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      systemd.extraCommands = ["systemctl --user start hyprpolkitagent"];
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
          gaps_in = 7;
          gaps_out = 7;
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
          rounding = 20;
          active_opacity = 1.0;
          inactive_opacity = 0.85;
          fullscreen_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };

          blur = {
            enabled = true;
            xray = true;
            special = false;
            new_optimizations = true;
            size = 7;
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
            "myBezier, 0.10, 0.9, 0.1, 1.05"
          ];
          animation = [
            "windows, 1, 4, myBezier, slide"
            "windowsOut, 1, 4, myBezier, slide"
            "border, 1, 10, default"
            "fade, 1, 7, md3_decel"
            "layersIn, 1, 3, menu_decel, slide"
            "layersOut, 1, 1.6, menu_accel"
            "fadeLayersIn, 1, 2, menu_decel"
            "fadeLayersOut, 1, 4.5, menu_accel"
            "workspaces, 1, 4, default"
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
          "$mod, q, exec, uwsm app -- $terminal"
          "$mod, c, killactive"
          "$mod, e, exec, uwsm app -- ${pkgs.xfce.thunar}/bin/thunar"
          "$mod, b, exec, uwsm app -- zen"
          "$mod SHIFT, e, exit"
          "$mod SHIFT, l, exec, uwsm app -- ${pkgs.hyprlock}/bin/hyprlock"

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
          #"$mod, r, exec, pkill fuzzel || uwsm app -- ${pkgs.fuzzel}/bin/fuzzel --launch-prefix='/run/current-system/sw/bin/uwsm app -- '"
          "$mod, r, exec, uwsm app -- ${pkgs.ulauncher}/bin/ulauncher-toggle"

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
        #exec-once = [ ];
      };
    };
  };
}
