{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    guiPrograms/hyprland.nix
    cliPrograms/minecraft_server.nix
  ];
}
