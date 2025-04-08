{pkgs, ...}: {
  users.users.lukewriglesworth.home = "/Users/lukewriglesworth";
  nix = {
    enable = true;
    package = pkgs.nixVersions.latest;
    settings.experimental-features = "nix-command flakes";
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
    gcc
    coreutils-full
    python313
    btop
    uv
    neovim
    nixd
    git
    lazygit
    home-manager
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

  services = {
    jankyborders.enable = true;
    sketchybar = {
      enable = true;
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
    aerospace = {
      enable = true;
      settings = {
        #exec-on-workspace-change = [
        #  "/bin/bash"
        #  "-c"
        # "sketchybar --trigger aerospace_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"
        #];
        gaps = {
          inner.horizontal = 10;
          inner.vertical = 10;
          outer.left = 8;
          outer.bottom = 8;
          outer.top = 4;
          outer.right = 8;
        };
        mode.main.binding = {
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";
          alt-8 = "workspace 8";
          alt-9 = "workspace 9";
          alt-0 = "workspace 10";
          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";
          alt-q = "exec-and-forget open -n ~/.nix-profile/Applications/WezTerm.app";
          alt-w = "close --quit-if-last-window";
        };
      };
    };
  };

  homebrew = {
    enable = true;
    casks = [
      "raycast"
      "ollama"
      "xquartz"
      "x2goclient"
      "ghostty"
    ];
  };
  system.startup.chime = false;
  system.defaults = {
    NSGlobalDomain._HIHideMenuBar = true;
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
