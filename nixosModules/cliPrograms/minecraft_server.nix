{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    minecraft_server.enable = lib.mkEnableOption "Enables Minecraft server";
  };
  config = lib.mkIf config.minecraft_server.enable {
    nixpkgs.overlays = [
      inputs.nix-minecraft.overlay
    ];
    services.minecraft-servers = {
      enable = true;
      eula = true;
      servers = {
        private-server = {
          enable = false;
          jvmOpts = "-Xms10000M -Xmx24000M";
          openFirewall = true;
          package = pkgs.paperServers.paper;
          whitelist = {
            lwrig = "ad2e45de-c695-4ffd-adae-bb1ebbe8e726";
            BulldakNoodlez = "df74fe63-1948-44c2-8cf1-11a0e5870c44";
          };
          serverProperties = {
            motd = "NixOS Minecraft Server";
            gamemode = "survival";
            difficulty = "normal";
            view-distance = 32;
            use-native-transport = true;
          };
          operators = {
            uuid = "ad2e45de-c695-4ffd-adae-bb1ebbe8e726";
          };
        };
        private-server2 = {
          enable = true;
          jvmOpts = "-Xms10000M -Xmx16000M";
          openFirewall = true;
          package = pkgs.paperServers.paper;
          whitelist = {
            lwrig = "ad2e45de-c695-4ffd-adae-bb1ebbe8e726";
            BulldakNoodlez = "df74fe63-1948-44c2-8cf1-11a0e5870c44";
          };
          serverProperties = {
            motd = "NixOS Minecraft Server 2";
            gamemode = "survival";
            difficulty = "normal";
            view-distance = 32;
            use-native-transport = true;
          };
          operators = {
            uuid = "ad2e45de-c695-4ffd-adae-bb1ebbe8e726";
          };
        };
      };
    };
  };
}
