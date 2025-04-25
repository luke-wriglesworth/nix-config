{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    zsh.enable = lib.mkEnableOption "Enables zsh configuration";
  };
  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = ./p10k-config;
          file = "p10k.zsh";
        }
      ];
      shellAliases = {
        "cfg" = "nvim ~/.nixos/config/nixos/configuration.nix";
        "hm" = "nvim ~/.nixos/home/common/home.nix";
      };
    };
  };
}
