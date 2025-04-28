{
  config,
  lib,
  inputs,
  ...
}: {
  options.lan-mouse.enable = lib.mkEnableOption "Enables lan-mouse configuration";
  imports = [inputs.lan-mouse.homeManagerModules.default];
  config = lib.mkIf config.lan-mouse.enable {
    programs.lan-mouse = {
      enable = true;
      systemd = true;
      settings = {
        clients = [
          {
            position = "bottom";
            activate_on_startup = true;
            hostname = "lukes-macbook-pro";
            ips = ["100.115.204.63"];
            port = 4242;
          }
        ];
      };
    };
  };
}
