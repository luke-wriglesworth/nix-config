{ pkgs, inputs, lib, ...}:

{

  imports = [ ./hardware-configuration.nix ];
  chaotic = {
    nyx.overlay.enable = true;
    mesa-git.enable = true;
    mesa-git.extraPackages = [ pkgs.mesa_git.opencl ];
    mesa-git.extraPackages32 = [ pkgs.mesa32_git.opencl ];
  };
  system.stateVersion = "24.11";

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-rc;
    kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
    loader.systemd-boot.enable = true;
    loader.systemd-boot.consoleMode = "auto";
    loader.systemd-boot.memtest86.enable = true;
    loader.systemd-boot.configurationLimit = 10;
    loader.efi.canTouchEfiVariables = true;
    kernel.sysctl = {
    "fs.inotify.max_user_watches"   = 1048576;   # default:  8192
    "fs.inotify.max_user_instances" =    1024;   # default:   128
    "fs.inotify.max_queued_events"  =   32768;   # default: 16384
    };
  };

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    package = pkgs.nixVersions.latest;
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
    settings = {
      cores = 24;
      max-jobs = 24;
      auto-optimise-store = false;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "luke" ];
      system-features = [ "benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-znver4" "gccarch-native"];
    };
  };

  nixpkgs.config.allowUnfree = true;
  time.timeZone = "US/Eastern";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];
  zramSwap.enable = true;

  networking = {
    hostName = "nixos";
    firewall.enable = false;
    networkmanager.enable = false;
    dhcpcd.enable = true;
    dhcpcd.extraConfig = '' nohook resolv.conf'';
    enableIPv6 = true;
  };

  environment.systemPackages = with pkgs; [
    gitkraken
    gh
    gh-copilot
    libreoffice
    lmstudio
    texlive.combined.scheme-full
    clinfo
    amdgpu_top
    en-croissant
    stockfish
    adwaita-icon-theme
    papirus-icon-theme
    mangohud
    mangojuice
    unzip
    nh
    zotero
    wget
    openrgb-with-all-plugins
    vlc
    udiskie
    git
    btop
    direnv
    qbittorrent
    vlc
    mesa-demos
    vulkan-tools
    thunderbird
    cacert
    nss
    lact
    openrazer-daemon
    polychromatic
    vscode-fhs
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    jellyfin-media-player
    vesktop
    nixd
    nix-index
    distrobox_git
    alejandra
  ] ++ [ inputs.zen-browser.packages."${system}".twilight-official ];
  
  environment.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
    TERMINAL = "wezterm";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  # stop kernel log spam from covering greeter
  systemd.services.greetd.serviceConfig = {
  Type = "idle";
  StandardInput = "tty";
  StandardOutput = "tty";
  StandardError = "journal";
  TTYReset = true;
  TTYVHangup = true;
  TTYVTDisallocate = true;
};

  virtualisation = {
    docker.enable = false;
    waydroid.enable = false;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  services = {
    scx.enable = false;
    scx.package = pkgs.scx_git.full;
    greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet";
      settings.default_session.user = "greeter";
    };
    jellyfin = {
      enable = true;
      user = "luke";
    };
    ollama = {
      enable = true;
      acceleration = "rocm";
      rocmOverrideGfx = "10.3.1";
    };
    fwupd.enable = true;
    udev.extraRules = '' SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3633", MODE="0666" '';
    udisks2.enable = true;
    open-webui = {
      enable = true;
      port = 8080;
    };
    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ "luke" ];
        UseDns = true;
        PermitRootLogin = "yes";
      };
    };
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "luke";
      configDir = "/home/luke/.config/syncthing";
        settings.gui = {
          user = "luke";
          password = "syncpass";
        };
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      extraConfig.pipewire = 
      {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
          };
        };
      };
    };
    dnsmasq = {
      enable = true;
      resolveLocalQueries = true;
      settings = {
        cache-size = 1000;
        bind-interfaces = true;
        server = ["1.1.1.1" "1.0.0.1"];
      };
    };
  };

  # Fonts
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts.serif = [ "IBM Plex Serif"];
      defaultFonts.sansSerif = [ "IBM Plex Sans "];
      defaultFonts.monospace = [ "JetBrains Mono" ];
      subpixel.rgba = "rgb";
      hinting.enable = true;
      hinting.style = "full";
    };
    packages = with pkgs; [
      ibm-plex
      jetbrains-mono
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };

  security = {
    polkit.enable = true;
    pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];
    rtkit.enable = true;
    pam.loginLimits = [{ domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }];
  };

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit= true;
    };
    amdgpu.initrd.enable = true;
    amdgpu.opencl.enable = true;
    openrazer.enable = false;
  };
  
  # User Account
  users.users.luke = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "render" "docker" "openrazer" "podman" ];
    home = "/home/luke";
   };

  programs = {
    nix-ld.enable = true;
    zsh.enable = true;
    appimage.enable=true;
    gamescope = {
      enable = true;
      capSysNice = true;
      package = pkgs.gamescope_git;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      gamescopeSession.args = [ "-H 1440" "-W 2560" "-r 165" 
                                "--mangoapp" "--hdr-enabled" 
                                "--adaptive-sync" "--hdr-sdr-content-nits 500" "-e" ];
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true; 
      localNetworkGameTransfers.openFirewall = true; 
    };
  };
}
