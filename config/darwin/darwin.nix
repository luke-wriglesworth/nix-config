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
    aerospace.enable = false;
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
