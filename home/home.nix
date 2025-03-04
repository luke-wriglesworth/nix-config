{ pkgs, ...}:
{
  home.username = "luke";
  home.homeDirectory = "/home/luke";
  home.stateVersion = "24.11";
  home.file = {};
  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 28;
};
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "Adwaita";
      size = 28;
      package = pkgs.gnome-themes-extra;
    };
  };
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
      ${pkgs.nitch}/bin/nitch
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
    enable = true;
    enableZshIntegration = true;
      settings = {
        theme = "catppuccin-macchiato";
        font-family = "UbuntuMono Nerd Font";
        font-size = 14;
      };
    };
  };
}
