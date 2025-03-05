{ pkgs, ...}:
let 
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.file = {};
  home.username = if isLinux then "luke" else "lukewriglesworth";
  home.homeDirectory = if isLinux then "/home/luke" else "/Users/lukewriglesworth";
  nixpkgs.config.allowUnfree = true;
  xdg.configFile."starship.toml".source = ./starship.toml;
  programs = {
    home-manager.enable = true;
    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable=true;
      enableCompletion = true;
      initExtra = ''
      eval "$(starship init zsh)"
      '';
    };

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
      local config = wezterm.config_builder()
      config.font_size = 12.0
      config.font = wezterm.font "Jetbrains Mono Nerd Font"
      config.color_scheme = 'Gruvbox Dark (Gogh)'
      config.enable_wayland = false
      config.window_padding = {
        left = '1cell',
        right = '1cell',
        top = '0.5cell',
        bottom = '0.5cell',
      }
      config.window_decorations = "TITLE | RESIZE"
      return config
      '';
    };
    
    ghostty = {
    enable = false;
    enableZshIntegration = true;
      settings = {
        theme = "catppuccin-macchiato";
        font-family = "UbuntuMono Nerd Font";
        font-size = 14;
      };
    };
  };
}
