{
  pkgs,
  inputs,
  lib,
  ...
}: {
  system.stateVersion = "24.11";

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-rc;
    kernelParams = ["amdgpu.ppfeaturemask=0xffffffff"];
    loader.systemd-boot.enable = true;
    loader.systemd-boot.consoleMode = "auto";
    loader.systemd-boot.memtest86.enable = true;
    loader.systemd-boot.configurationLimit = 10;
    loader.efi.canTouchEfiVariables = true;
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 1048576; # default:  8192
      "fs.inotify.max_user_instances" = 1024; # default:   128
      "fs.inotify.max_queued_events" = 32768; # default: 16384
    };
  };

  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
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
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "luke"];
      system-features = ["benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-znver4" "gccarch-native"];
    };
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = pkgs: {
    x2goserver = let
      pkgs-x2go = import (builtins.fetchGit {
        name = "pinned-x2goserver";
        url = "https://github.com/nixos/nixpkgs/";
        ref = "refs/heads/nixos-unstable";
        rev = "0aa475546ed21629c4f5bbf90e38c846a99ec9e9";
      }) {system = "x86_64-linux";};
    in
      pkgs-x2go.x2goserver;
  };

  time.timeZone = "US/Eastern";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];
  zramSwap.enable = true;

  networking = {
    firewall.enable = false;
    hostName = "nixos";
    networkmanager.enable = false;
    dhcpcd.enable = true;
    dhcpcd.extraConfig = ''nohook resolv.conf'';
    enableIPv6 = true;
  };

  environment.systemPackages = with pkgs;
    [
      ncdu
      unityhub
      ripgrep
      prismlauncher
      gitkraken
      lutris
      evince
      element-desktop
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
      qbittorrent
      vlc
      mesa-demos
      vulkan-tools
      thunderbird
      cacert
      nss
      lact
      #openrazer-daemon
      polychromatic
      vscode-fhs
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
      jellyfin-media-player
      discord
      nixd
      nix-index
      distrobox_git
      alejandra
      podman-tui
      lazygit
    ]
    ++ [inputs.zen-browser.packages."${system}".twilight];

  environment.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
    TERMINAL = "wezterm";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  systemd.services = {
    lact = {
      enable = true;
      description = "AMDGPU Control Daemon";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };
    };
    ethtool = {
      enable = true;
      wantedBy = ["multi-user.target"];
      description = "UDP GRO forwarding for tailscale server";
      #environment = {NETDEV = "$(ip -o route get 8.8.8.8 | cut -f 5 -d ' ')";};
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.ethtool}/bin/ethtool -K enp8s0 rx-udp-gro-forwarding on rx-gro-list off";
      };
    };
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
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services = {
    x2goserver.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      extraSetFlags = ["--advertise-exit-node" "--ssh=true"];
    };
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
      openFirewall = true;
      host = "0.0.0.0";
      port = 11434;
      environmentVariables = {OLLAMA_MAX_LOADED_MODELS = "1";};
    };
    fwupd.enable = true;
    udev.extraRules = ''SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3633", MODE="0666" '';
    udisks2.enable = true;
    open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = 8080;
      openFirewall = true;
    };
    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        UsePAM = true;
        AllowUsers = ["luke"];
        UseDns = true;
        X11Forwarding = true;
        PermitRootLogin = "no";
        PrintMotd = true;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      extraConfig.pipewire = {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.allowed-rates" = [44100 48000 88200 96000 176400 192000];
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
      defaultFonts.serif = ["IBM Plex Serif"];
      defaultFonts.sansSerif = ["IBM Plex Sans "];
      defaultFonts.monospace = ["JetBrains Mono"];
      subpixel.rgba = "rgb";
      hinting.enable = true;
      hinting.style = "full";
    };
    packages = with pkgs;
      [
        ibm-plex
        jetbrains-mono
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };

  security = {
    polkit.enable = true;
    pki.certificateFiles = ["${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"];
    rtkit.enable = true;
    pam.loginLimits = [
      {
        domain = "*";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.initrd.enable = true;
    amdgpu.opencl.enable = true;
    #openrazer.enable = true;
  };

  # User Account
  users.users.luke = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "video" "render" "docker" "openrazer" "podman"];
    home = "/home/luke";
  };

  programs = {
    xwayland.enable = true;
    ssh = {
      forwardX11 = true;
      setXAuthLocation = true;
    };
    nix-ld.enable = false;
    zsh.enable = true;
    appimage.enable = true;
    gamescope = {
      enable = true;
      capSysNice = true;
      package = pkgs.gamescope_git;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
