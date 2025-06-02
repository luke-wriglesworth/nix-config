{
  pkgs,
  inputs,
  lib,
  pkgs-pinned,
  ...
}: {
  ## Custom Nix Modules ##
  hyprland.enable = true;
  ########################

  chaotic.mesa-git.enable = true;

  system.stateVersion = "24.11";
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
    tmp = {
      useTmpfs = true;
      tmpfsHugeMemoryPages = "within_size";
      cleanOnBoot = true;
    };
  };
  nix = {
    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
        to = {
          type = "path";
          path = pkgs.path;
        };
      };
    };
    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/home/luke/nix-config/hosts/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
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
  networking = {
    firewall.enable = false;
    resolvconf.enable = false;
    hostName = "nixos";
    networkmanager = {
      dns = "dnsmasq";
      enable = true;
      settings = {
        "global-dns-domain-*" = {
          "servers" = "1.1.1.1,1.0.0.1,2606:4700:4700::1111,2606:4700:4700::1001";
        };
      };
      ensureProfiles.profiles = {
        "Ethernet Connection" = {
          connection.type = "ethernet";
          connection.id = "Ethernet Connection";
          connection.interface-name = "enp8s0";
          connection.autoconnect = true;
          ipv4 = {
            method = "manual";
            ignore-auto-dns = true;
            addresses = "10.0.0.194";
            gateway = "10.0.0.1";
          };
        };
      };
    };
    dhcpcd.enable = true;
    dhcpcd.extraConfig = ''nohook resolv.conf'';
    enableIPv6 = true;
  };

  environment.etc = {
    "NetworkManager/dnsmasq.d/cache.conf".text = "cache-size=50000";
    "NetworkManager/dnsmasq.d/ipv6-listen.conf".text = "listen-address=::1";
  };
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
    nixos-cli = {
      enable = true;
    };
    tika = {
      enable = true;
    };
    searx = {
      enable = true;
      redisCreateLocally = true;
      environmentFile = "/home/luke/.searxng.env";
      settings.server = {
        port = 8081;
        bind_address = "::1";
      };
      settings.search.formats = ["html" "json"];
    };
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
      rocmOverrideGfx = "12.0.1";
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
      package = pkgs.openrgb-with-all-plugins;
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
        PasswordAuthentication = true;
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
    extraGroups = ["networkmanager" "wheel" "video" "render" "docker" "podman"];
    home = "/home/luke";
  };

  programs = {
    gamescope = {
      enable = true;
      package = inputs.chaotic.packages.x86_64-linux.gamescope_git;
    };
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
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  minecraft_server.enable = false;
}
