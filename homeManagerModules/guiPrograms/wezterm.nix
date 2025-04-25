{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    wezterm.enable = lib.mkEnableOption "Enables wezterm configuration";
  };
  config = lib.mkIf config.wezterm.enable {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
        local config = wezterm.config_builder()
                   config.font = wezterm.font "JetbrainsMono Nerd Font"
                   config.enable_wayland = true
                   config.audible_bell = "Disabled"
        config.window_close_confirmation = 'NeverPrompt'
             			config.enable_tab_bar = false
                   config.window_padding = {
        	left = '1cell',
        	right = '1cell',
        	top =0,
        	bottom = 0,
        }
        ${lib.optionalString pkgs.stdenv.isLinux "config.window_decorations = 'NONE'"}
        ${
          if pkgs.stdenv.isDarwin
          then "config.font_size = 16.0"
          else "config.font_size = 14.0"
        }
        return config
      '';
    };
  };
}
