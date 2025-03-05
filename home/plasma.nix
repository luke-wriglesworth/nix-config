{ ... }:

{
  imports = [ ./home.nix ];  
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


  programs.plasma = {
    enable = true;
    overrideConfig = false;
    powerdevil = {
      AC.powerProfile = "performance";
      AC.powerButtonAction = "shutDown";
      AC.displayBrightness = 100;
      AC.autoSuspend.action = "nothing";
    };

    input.mice = [{
      acceleration = 0.0;
      accelerationProfile = "none";
      enable = true;
      leftHanded = false;
      name = "Razer Viper V3 Pro";
      productId = "1532";
      vendorId = "00c1";
    }];

    workspace = {
      #lookAndFeel = "org.kde.breezedark.desktop";
      theme = "Utterly-Nord";
      colorScheme = "Utterly-Nord";
      windowDecorations.theme = "Breeze";
      windowDecorations.library = "org.kde.breeze";
      iconTheme = "Breeze Dark";
      wallpaper = "/home/luke/Pictures/nixos.png";
    };

    panels = [
      # Windows-like panel at the bottom
      {
        location = "bottom";
        widgets = [
          # We can configure the widgets by adding the name and config
          # attributes. For example to add the the kickoff widget and set the
          # icon to "nix-snowflake-white" use the below configuration. This will
          # add the "icon" key to the "General" group for the widget in
          # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake-white";
                alphaSort = true;
              };
            };
          }
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:systemsettings.desktop"
                "applications:com.mitchellh.ghostty.desktop"
                "applications:firefox-nightly.desktop"
                "applications:code.desktop"
                "applications:discord-ptb.desktop"
		            "applications:thunderbird.desktop"
	      ];
            };
          }
          # If no configuration is needed, specifying only the name of the
          # widget will add them with the default configuration.
          "org.kde.plasma.marginsseparator"
          # If you need configuration for your widget, instead of specifying the
          # the keys and values directly using the config attribute as shown
          # above, plasma-manager also provides some higher-level interfaces for
          # configuring the widgets. See modules/widgets for supported widgets
          # and options for these widgets. The widgets below shows two examples
          # of usage, one where we add a digital clock, setting 12h time and
          # first day of the week to Sunday and another adding a systray with
          # some modifications in which entries to show.
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              time.format = "12h";
            };
          }
          {
            systemTray.items = {
              # We explicitly show bluetooth and battery
              shown = [
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
            };
          }
        ];
        hiding = "dodgewindows";
      }
      # {
      #   location = "top";
      #   height = 26;
      #   widgets = [
      #     {
      #       applicationTitleBar = {
      #         behavior = {
      #           activeTaskSource = "activeTask";
      #         };
      #         layout = {
      #           elements = [ "windowIcon" "windowTitle" ];
      #           horizontalAlignment = "left";
      #           showDisabledElements = "deactivated";
      #           verticalAlignment = "center";
      #         };
      #         overrideForMaximized.enable = false;
      #         windowTitle = {
      #           font = {
      #             bold = false;
      #             fit = "fixedSize";
      #             size = 12;
      #           };
      #           hideEmptyTitle = true;
      #           margins = {
      #             bottom = 0;
      #             left = 10;
      #             right = 5;
      #             top = 0;
      #           };
      #           source = "appName";
      #         };
      #       };
      #     }
      #     "org.kde.plasma.appmenu"
      #     "org.kde.plasma.panelspacer"
      #   ];
      # }
    ];
    kwin = {
      #edgeBarrier = null; # Disables the edge-barriers introduced in plasma 6.1
      cornerBarrier = false;
      borderlessMaximizedWindows = false;
      effects.blur.enable = true;
      effects.shakeCursor.enable = false;
      effects.translucency.enable = true;
    };
    kscreenlocker = {
      lockOnResume = false;
      timeout = 10;
    };

    #
    # Some mid-level settings:
    #
    shortcuts = {
      ksmserver = {
        "Lock Session" = [
          "Screensaver"
          "Meta+Ctrl+Alt+L"
        ];
      };

      kwin = {
        "Expose" = "Meta+,";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";
      };
    };
    configFile = {
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;
      kscreenlockerrc = {
        Greeter.WallpaperPlugin = "org.kde.potd";
        # To use nested groups use / as a separator. In the below example,
        # Provider will be added to [Greeter][Wallpaper][org.kde.potd][General].
        "Greeter/Wallpaper/org.kde.potd/General".Provider = "bing";
      };
    };
  };
}
