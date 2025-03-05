{ pkgs, ...}:
let 
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.file = {};
  home.username = if isLinux then "luke" else "lukewriglesworth";
  home.homeDirectory = if isLinux then /home/luke else /Users/lukewriglesworth;
  nixpkgs.config.allowUnfree = true;
  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      plugins = [
        {name = pkgs.zsh-autosuggestions.pname; src = pkgs.zsh-autosuggestions.src;}
        {name = pkgs.zsh-autocomplete.pname; src = pkgs.zsh-autocomplete.src;}
        {name = pkgs.zsh-syntax-highlighting.pname; src = pkgs.zsh-syntax-highlighting.src;}
        {name = pkgs.pure-prompt.pname; src = pkgs.pure-prompt.src;}
        {name = pkgs.zsh-you-should-use.pname; src = pkgs.zsh-you-should-use.src;}
        {name = pkgs.thefuck.pname; src = pkgs.thefuck.src;}
      ];
      initExtra = ''
      autoload -U promptinit; promptinit
      prompt pure
      '';
    };

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
      local config = wezterm.config_builder()
      config.font_size = 12.0
      config.font = wezterm.font "JetBrains Mono"
      config.color_scheme = 'Catppuccin Macchiato'
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
