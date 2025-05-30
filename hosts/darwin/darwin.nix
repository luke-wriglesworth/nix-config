{
  pkgs,
  lib,
  inputs,
  ...
}: {
  users.users.lukewriglesworth.home = "/Users/lukewriglesworth";
  nix = {
    enable = false;
    settings = {
      "extra-experimental-features" = ["nix-command" "flakes"];
    };
  };
  system.stateVersion = 6;
  system.primaryUser = "lukewriglesworth";
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  fonts = {
    packages = with pkgs;
      [
        ibm-plex
        jetbrains-mono
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };
  environment.variables = {
    OLLAMA_HOST = "0.0.0.0";
  };

  environment.systemPackages = with pkgs; [
    bitwarden
    utm
    prismlauncher
    ncurses
    coreutils-full
    ffmpeg
    nixd
    git
    lazygit
    gh
    gh-copilot
    home-manager
    inputs.nh.packages."aarch64-darwin".default
  ];

  networking = {
    knownNetworkServices = [
      "USB 10/100/1000 LAN"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  };
  launchd.user.agents = {
    #yabai.serviceConfig.Label = "com.koekeishiya.yabai";
    #skhd.serviceConfig.Label = "com.koekeishiya.skhd";
  };
  services = {
    yabai = {
      enable = false;
      enableScriptingAddition = true;
      config = {
        layout = "bsp";
        focus_follows_mouse = "autoraise";
        mouse_follows_focus = "off";
        window_placement = "second_child";
        window_opacity = "off";
        top_padding = 10;
        bottom_padding = 10;
        left_padding = 10;
        right_padding = 10;
        window_gap = 10;
      };
    };
    skhd = {
      enable = false;
      skhdConfig = ''
            alt - h : yabai -m window --focus west
            alt - j : yabai -m window --focus south
            alt - k : yabai -m window --focus north
            alt - l : yabai -m window --focus east
            shift + alt - h : yabai -m window --warp west
            shift + alt - j : yabai -m window --warp south
            shift + alt - k : yabai -m window --warp north
            shift + alt - l : yabai -m window --warp east
            alt - 1 : yabai -m space --focus 1
            alt - 2 : yabai -m space --focus 2
            alt - 3 : yabai -m space --focus 3
            alt - 4 : yabai -m space --focus 4
            alt - 5 : yabai -m space --focus 5
            shift + alt - 1 : yabai -m window --space 1
            shift + alt - 2 : yabai -m window --space 2
            shift + alt - 3 : yabai -m window --space 3
            shift + alt - 4 : yabai -m window --space 4
            shift + alt - 5 : yabai -m window --space 5
            alt - c : yabai -m window --close
            alt - q : open -n ~/.nix-profile/Applications/WezTerm.app
        alt - b : open -n /Applications/Safari.app
      '';
    };

    jankyborders.enable = false;
    tailscale = {
      enable = true;
    };
  };

  homebrew = {
    enable = true;
    casks = [
      "raycast"
      "ollama"
      "ghostty"
    ];
  };
  system.startup.chime = false;
  system.defaults = {
    NSGlobalDomain._HIHideMenuBar = false;
    dock = {
      autohide = true;
      orientation = "left";
      show-process-indicators = true;
      show-recents = true;
      static-only = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
  };
}
