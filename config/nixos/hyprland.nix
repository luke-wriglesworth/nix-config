{ inputs, pkgs, ... }:
{
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
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland.override{
                mesa = pkgs.mesa_git;
            };
            portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland.override{
                mesa = pkgs.mesa_git;
            };
            withUWSM = true;
        };
        uwsm = {
            enable = true;
            waylandCompositors = {
                hyprland = {
                    prettyName = "Hyprland";
                    comment = "Hyprland compositor managed by UWSM";
                    binPath = "/run/current-system/sw/bin/Hyprland";
                };      
            };
        };
        dconf.enable = true;
    };

    qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
    };
}
 
