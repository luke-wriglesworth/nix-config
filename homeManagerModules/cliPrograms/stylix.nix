{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [inputs.stylix.homeManagerModules.stylix];
  options.stylixConfig.enable = lib.mkEnableOption "Enables stylix configuration";
  config = lib.mkIf config.stylixConfig.enable {
    stylix = {
      enable = true;
      targets.mako.enable = false;
      targets.gnome.enable = false;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      image = ./nixos.png;
      #cursor = {
      #  size = 28;
      #  name = "Adwaita";
      #  package = lib.mkDefault pkgs.adwaita-icon-theme;
      #cursor = null;
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetbrainsMono Nerd Font Mono";
        };
        serif = config.stylix.fonts.sansSerif;
        sansSerif = {
          package = pkgs.nerd-fonts.noto;
          name = "NotoSans Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
