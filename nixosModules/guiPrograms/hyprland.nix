{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  hyprland-git = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  options = {
    hyprland.enable = lib.mkEnableOption "Enables Hyprland configuration";
  };
  config = lib.mkIf config.hyprland.enable {
    environment.systemPackages = [
      pkgs.wl-clipboard
      pkgs.slurp
      pkgs.grim
      pkgs.pavucontrol
      pkgs.waybar
      pkgs.qt5.qtwayland
      pkgs.qt6.qtwayland
      pkgs.papirus-icon-theme
      pkgs.hyprlock
      pkgs.hypridle
      pkgs.hyprpolkitagent
      pkgs.hyprsunset
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    ];
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    programs = {
      hyprland = {
        enable = true;
        xwayland.enable = true;
        package = hyprland-git.hyprland;
        portalPackage = hyprland-git.xdg-desktop-portal-hyprland;
        withUWSM = true;
      };
      dconf.enable = true;
    };
    qt = {
      enable = true;
    };
  };
}
