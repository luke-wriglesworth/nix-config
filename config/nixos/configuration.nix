{
  pkgs,
  inputs,
  lib,
  pkgs-pinned,
  ...
}: {
  system.stateVersion = "24.11";
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
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

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  };

  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    package = pkgs.nixVersions.latest;
    settings = {
      cores = 24;
      max-jobs = 24;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "luke"];
      system-features = ["benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-znver4" "gccarch-native"];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      inputs.nix-minecraft.overlay
      (final: prev: {
        pythonPackagesExtensions =
          prev.pythonPackagesExtensions
          ++ [
            #(pyfinal: pyprev: {
            #  gcp-storage-emulator = pyprev.gcp-storage-emulator.overridePythonAttrs (oldAttrs: {
            #    doCheck = false;
            #  });
            #  tencentcloud-sdk-python = pyprev.tencentcloud-sdk-python.overridePythonAttrs (oldAttrs: {
            #    doCheck = false;
            #  });
            #})
          ];
      })
    ];
  };

  time = {
    timeZone = "US/Eastern";
    #hardwareClockInLocalTime = true;
  };
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
    openrgb-with-all-plugins
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
    #mathematica
    (mathematica.override {
      source = pkgs.requireFile {
        name = "Wolfram_14.2.1_LIN_Bndl.sh";
        # Get this hash via a command similar to this:
        # nix-store --query --hash \
        # $(nix store add-path Mathematica_XX.X.X_BNDL_LINUX.sh --name 'Mathematica_XX.X.X_BNDL_LINUX.sh')
        sha256 = "095i1z3rc3p5mdaif367k4vcaf4mzcszpbmnva17zm5zxl7y7vl1";
        message = ''
          Your override for Mathematica includes a different src for the installer,
          and it is missing.
        '';
        hashMode = "recursive";
      };
    })
    inputs.nh.packages."x86_64-linux".default
    inputs.zen-browser.packages."${system}".twilight-official
  ];
  environment.enableAllTerminfo = true;
  environment.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
    TERMINAL = "wezterm";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  systemd.packages = [pkgs.lact];
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
    minecraft-servers = {
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
      extraPackages = [pkgs.rocmPackages.clr.icd];
    };
    amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
    };
  };

  # User Account
  users.users.luke = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "video" "render" "docker" "podman"];
    home = "/home/luke";
  };

  programs = {
    xwayland.enable = true;
    ssh = {
      forwardX11 = true;
      setXAuthLocation = true;
      startAgent = true;
    };
    nix-ld.enable = false;
    zsh.enable = true;
    appimage.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
