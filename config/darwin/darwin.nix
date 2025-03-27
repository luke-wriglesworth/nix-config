{pkgs, ...}: {
  users.users.lukewriglesworth.home = "/Users/lukewriglesworth";
  nix.package = pkgs.nixVersions.latest;
  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = true;
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
    gcc
    wezterm
    texlive.combined.scheme-full
    python313
    btop
    uv
    neovim
    nixd
    git
    lazygit
    raycast
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
    tailscale = {
      enable = true;
    };
    aerospace = {
      enable = true;
      settings = {
        gaps = {
          outer.left = 0;
          outer.bottom = 0;
          outer.top = 0;
          outer.right = 0;
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
          alt-q = "exec-and-forget open -n /nix/store/j9pqrichkzmk3y5zva23ny8y82yqkdnn-system-applications/Applications/WezTerm.app";
          alt-w = "close --quit-if-last-window";
        };
      };
    };
  };

  homebrew = {
    enable = true;
    global.autoUpdate = true;

    casks = [
      "ollama"
      "xquartz"
      "x2goclient"
    ];
    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };
  };
}
