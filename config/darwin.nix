{ pkgs, ... }:

{
  users.users.lukewriglesworth.home = "/Users/lukewriglesworth";

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
    nix.settings.experimental-features = "nix-command flakes";
    nix.enable = false;
    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
    nixpkgs.config.allowUnfree = true;
}