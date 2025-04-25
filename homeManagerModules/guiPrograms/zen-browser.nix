{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  options.zen-browser.enable = lib.mkEnableOption "Enables zen-browser configuration";
  config = lib.mkIf config.zen-browser.enable {
    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [pkgs.firefoxpwa];
    };
  };
}
