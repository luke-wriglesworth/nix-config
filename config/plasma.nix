{pkgs, ...}:

{
  config = {
    services = {
      desktopManager.plasma6.enable = true;
      desktopManager.plasma6.enableQt5Integration = true;
      displayManager ={
        sddm.enable = true;
        sddm.wayland.enable = true;
        sddm.theme = "breeze";
        defaultSession = "plasma";
      };
      xserver = {
        enable = true;
        xkb = {
          layout = "us,ru";
          variant = ",phonetic_mac";
          options = "grp:win_space_toggle";
        };      
      };
    };
    environment.systemPackages = with pkgs; [
      utterly-nord-plasma
      adwaita-qt
      adwaita-qt6
      qgnomeplatform-qt6
      qgnomeplatform
      qadwaitadecorations-qt6
      qadwaitadecorations
      kdePackages.full
      kdePackages.wayland
      kdePackages.qtwayland
      kdePackages.okular
      application-title-bar
      seahorse
    ];
    programs.dconf.enable = true;
  };
}
