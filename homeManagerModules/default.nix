{
  pkgs,
  config,
  ...
}:
# Configs common between all machines
{
  programs.home-manager.enable = true;
  imports = [
    ./cliPrograms/neovim.nix
    ./cliPrograms/zsh.nix
    ./cliPrograms/stylix.nix
    ./cliPrograms/lan-mouse.nix
    ./guiPrograms/wezterm.nix
    ./guiPrograms/zen-browser.nix
    ./guiPrograms/hyprpanel.nix
    ./guiPrograms/hyprland.nix
  ];
  home.packages = with pkgs; [dust];
  neovim.enable = true;
  zsh.enable = true;
  wezterm.enable = true;
  stylixConfig.enable = true;
  nixpkgs.config.allowUnfree = true;

  programs = {
    btop.enable = true;
    htop.enable = true;
    eza = {
      enable = true;
      enableZshIntegration = true;
    };
    bat.enable = true;
    ripgrep-all.enable = true;
    ripgrep.enable = true;
    mcfly = {
      enable = true;
      enableZshIntegration = true;
    };
    fd.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    zellij = {
      enable = true;
      enableZshIntegration = true;
      attachExistingSession = true;
      settings = {
        show_startup_tips = false;
      };
    };
    ghostty = {
      enable = false;
      enableZshIntegration = true;
      package =
        if pkgs.stdenv.isLinux
        then pkgs.ghostty
        else null;
      settings = {
        font-family = "${config.stylix.fonts.monospace.name}";
        font-size = 13;
        confirm-close-surface = false;
      };
    };
  };
}
