{inputs, ...}: {
  imports = [inputs.lan-mouse.homeManagerModules.default];
  programs.lan-mouse = {
    enable = true;
    settings.authorized_fingerprints = {"55:f5:98:93:c6:c8:ec:b7:cd:36:30:e3:ab:5b:fb:ae:18:fc:dd:d2:3e:8f:19:5a:b5:3b:ef:92:64:89:82:05" = "nixos";};
  };
}
