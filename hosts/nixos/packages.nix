{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    lan-mouse
    nomachine-client
    comma
    devdocs-desktop
    unityhub
    ripgrep
    (prismlauncher.override {
      additionalPrograms = [];
      jdks = [pkgs.jdk23 pkgs.jdk21];
    })
    gitkraken
    evince
    element-desktop
    gh
    gh-copilot
    libreoffice
    lmstudio
    clinfo
    amdgpu_top
    en-croissant
    stockfish
    adwaita-icon-theme
    papirus-icon-theme
    mangohud
    mangojuice
    unzip
    zotero
    wget
    vlc
    udiskie
    git
    qbittorrent
    vlc
    mesa-demos
    vulkan-tools
    thunderbird
    cacert
    nss
    lact
    vscode-fhs
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    jellyfin-media-player
    discord
    nixd
    nix-index
    distrobox
    alejandra
    podman-tui
    lazygit
    hydra-check
    mathematica
    #(mathematica.override {
    #  source = pkgs.requireFile {
    #    name = "Wolfram_14.2.1_LIN_Bndl.sh";
    #    # Get this hash via a command similar to this:
    #    # nix-store --query --hash \
    #    # $(nix store add-path Mathematica_XX.X.X_BNDL_LINUX.sh --name 'Mathematica_XX.X.X_BNDL_LINUX.sh')
    #    sha256 = "095i1z3rc3p5mdaif367k4vcaf4mzcszpbmnva17zm5zxl7y7vl1";
    #    message = ''
    #      Your override for Mathematica includes a different src for the installer,
    #      and it is missing.
    #    '';
    #    hashMode = "recursive";
    #  };
    #})
    inputs.nh.packages."x86_64-linux".default
  ];
}
