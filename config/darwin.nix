{ pkgs, ... }:

{
  users.users.lukewriglesworth.home = "/Users/lukewriglesworth";
  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = false;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  fonts = {
    packages = with pkgs; [
      ibm-plex
      jetbrains-mono
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };

  environment.systemPackages = with pkgs; [ 
      gcc
      wezterm
      texlive.combined.scheme-full
      python313
      btop
      neovim
      nixd
      git
    ];

    networking = {
      knownNetworkServices = 
        [ 
        "USB 10/100/1000 LAN"
        "Thunderbolt Bridge"
        "Wi-Fi"
        ];
      dns = 
      [
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
    };

    homebrew = {
      enable = true;
      casks = [
        "ollama"
      ];
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
    };
}
