{ pkgs, self, ... }:

{
  users.users.lukewriglesworth.home = /Users/lukewriglesworth;
  environment.systemPackages = with pkgs; [ 
      neovim
      fastfetch
      cmatrix
      gcc
      wezterm
      texlive.combined.scheme-full
      python313
      btop
    ];
    nix.settings.experimental-features = "nix-command flakes";
    nix.enable = false;
    #system.configurationRevision = self.rev or self.dirtyRev or null;
    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
    nixpkgs.config.allowUnfree = true;
}