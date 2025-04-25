{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.stylixConfig.enable = lib.mkEnableOption "Enables stylix configuration";
  config = lib.mkIf config.stylixConfig.enable {
    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
      image = "${inputs.nixos-artwork}/wallpapers/nix-wallpaper-binary-black.png";
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
