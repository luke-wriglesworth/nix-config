{
  pkgs,
  lib,
  inputs,
  ...
}: {
  users.users.lukewriglesworth.home = "/Users/lukewriglesworth";
  nix = {
    enable = false;
  };
  system.stateVersion = 6;
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
    ncurses
    coreutils-full
    btop
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
  services = {
    yabai = {
      enable = true;
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
      enable = true;
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

    jankyborders.enable = true;
    sketchybar = {
      enable = false;
      config = ''
              sketchybar --bar position=top height=40 blur_radius=30 color=0x40000000
              default=(
              	padding_left=5
              	padding_right=5
              	icon.font="Hack Nerd Font:Bold:17.0"
              	label.font="Hack Nerd Font:Bold:14.0"
              	icon.color=0xffffffff
              	label.color=0xffffffff
              	icon.padding_left=4
              	icon.padding_right=4
              	label.padding_left=4
              	label.padding_right=4
              	)
              	sketchybar --default "''${default[@]}"
        sketchybar --add event aerospace_workspace_change

        for sid in $(aerospace list-workspaces --all); do
        		sketchybar --add item space.$sid left \
        				--subscribe space.$sid aerospace_workspace_change \
        				--set space.$sid \
        				background.color=0x44ffffff \
        				background.corner_radius=5 \
        				background.height=20 \
        				background.drawing=off \
        				label="$sid" \
        				click_script="aerospace workspace $sid" \
        				script="$CONFIG_DIR/plugins/aerospace.sh $sid"
        done
              	sketchybar --update
              	echo "sketchybar loaded..."
      '';
      extraPackages = [pkgs.lua5_4 pkgs.jq];
    };
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
      show-process-indicators = false;
      show-recents = false;
      static-only = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
  };
}
