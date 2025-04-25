{
  config,
  lib,
  inputs,
  ...
}: let
  accent = "#${config.lib.stylix.colors.base0D}";
  accent-alt = "#${config.lib.stylix.colors.base03}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";
  foreground = "#${config.lib.stylix.colors.base05}";
in {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];
  options.hyprpanel.enable = lib.mkEnableOption "Enables hyprpanel configuration";
  config = lib.mkIf config.hyprpanel.enable {
    programs.hyprpanel = {
      enable = true;
      overlay.enable = true;
      hyprland.enable = true;
      overwrite.enable = true;
      settings = {
        layout = {
          "bar.layouts" = {
            "0" = {
              left = ["dashboard" "workspaces" "windowtitle"];
              middle = ["media" "cava"];
              right = ["volume" "cpu" "ram" "systray" "bluetooth" "clock" "notifications"];
            };
          };
        };
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
      };
      override = {
        "theme.bar.buttons.workspaces.hover" = "${accent-alt}";
        "theme.bar.buttons.workspaces.active" = "${accent}";
        "theme.bar.buttons.workspaces.available" = "${accent-alt}";
        "theme.bar.buttons.workspaces.occupied" = "${accent-alt}";

        "theme.bar.menus.monochrome" = true;
        "wallpaper.enable" = false;
        "theme.bar.menus.background" = "${background}";
        "theme.bar.menus.cards" = "${background-alt}";
        "theme.bar.menus.label" = "${foreground}";
        "theme.bar.menus.text" = "${foreground}";
        "theme.bar.menus.border.color" = "${accent}";
        "theme.bar.menus.popover.text" = "${foreground}";
        "theme.bar.menus.popover.background" = "${background-alt}";
        "theme.bar.menus.listitems.active" = "${accent}";
        "theme.bar.menus.icons.active" = "${accent}";
        "theme.bar.menus.switch.enabled" = "${accent}";
        "theme.bar.menus.check_radio_button.active" = "${accent}";
        "theme.bar.menus.buttons.default" = "${accent}";
        "theme.bar.menus.buttons.active" = "${accent}";
        "theme.bar.menus.iconbuttons.active" = "${accent}";
        "theme.bar.menus.progressbar.foreground" = "${accent}";
        "theme.bar.menus.slider.primary" = "${accent}";
        "theme.bar.menus.tooltip.background" = "${background-alt}";
        "theme.bar.menus.tooltip.text" = "${foreground}";
        "theme.bar.menus.dropdownmenu.background" = "${background-alt}";
        "theme.bar.menus.dropdownmenu.text" = "${foreground}";
        "theme.bar.background" = "${background}";
        "theme.bar.buttons.style" = "default";
        "theme.bar.buttons.monochrome" = true;
        "theme.bar.buttons.text" = "${foreground}";
        "theme.bar.buttons.background" = "${background-alt}";
        "theme.bar.buttons.icon" = "${accent}";
        "theme.bar.buttons.notifications.background" = "${background-alt}";
        "theme.bar.buttons.hover" = "${background}";
        "theme.bar.buttons.notifications.hover" = "${background}";
        "theme.bar.buttons.notifications.total" = "${accent}";
        "theme.bar.buttons.notifications.icon" = "${accent}";
        "theme.osd.bar_color" = "${accent}";
        "theme.osd.bar_overflow_color" = "${accent-alt}";
        "theme.osd.icon" = "${background}";
        "theme.osd.icon_container" = "${accent}";
        "theme.osd.label" = "${accent}";
        "theme.osd.bar_container" = "${background-alt}";
        "theme.bar.menus.menu.media.background.color" = "${background-alt}";
        "theme.bar.menus.menu.media.card.color" = "${background-alt}";
        "theme.bar.menus.menu.media.card.tint" = 90;
        "bar.customModules.updates.pollingInterval" = 1440000;
        "bar.media.show_active_only" = true;
        "bar.workspaces.numbered_active_indicator" = "color";
        "bar.workspaces.monitorSpecific" = false;
        "bar.workspaces.applicationIconEmptyWorkspace" = "";
        "theme.bar.menus.shadow" = "0px 0px 3px 1px #16161e";
        "bar.customModules.cava.showIcon" = false;
        "bar.customModules.cava.stereo" = true;
        "bar.customModules.cava.showActiveOnly" = true;
        "notifications.position" = "top right";
        "notifications.showActionsOnHover" = true;
        "theme.notification.enableShadow" = true;
        "theme.notification.background" = "${background-alt}";
        "theme.notification.actions.background" = "${accent}";
        "theme.notification.actions.text" = "${foreground}";
        "theme.notification.label" = "${accent}";
        "theme.notification.border" = "${background-alt}";
        "theme.notification.text" = "${foreground}";
        "theme.notification.labelicon" = "${accent}";
        "theme.notification.close_button.background" = "${background-alt}";
        "theme.notification.close_button.label" = "#f38ba8";
      };
    };
  };
}
