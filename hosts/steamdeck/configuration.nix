# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    package = pkgs.nixVersions.latest;
    distributedBuilds = true;
    settings = {
      max-jobs = 0;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "luke"];
      builders-use-substitutes = true;
    };
    buildMachines = [
      {
        sshUser = "luke";
        hostName = "nixos";
        sshKey = "/home/luke/.ssh/nixos";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        maxJobs = 24;
        speedFactor = 100;
        supportedFeatures = ["benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-znver4" "gccarch-native"];
        mandatoryFeatures = [];
      }
    ];
  };

  # jovian
  jovian = {
    decky-loader = {
      enable = true;
    };
    devices.steamdeck = {
      enable = true;
      autoUpdate = true;
      enableDefaultStage1Modules = true;
      enableFwupdBiosUpdates = true;
      enableKernelPatches = true;
      enableControllerUdevRules = true;
      enablePerfControlUdevRules = true;
      enableGyroDsuService = true;
      enableOsFanControl = true;
      enableSoundSupport = true;
    };
    steam = {
      enable = true;
      desktopSession = "gnome";
      autoStart = true;
      user = "luke";
    };
    steamos = {
      enableAutoMountUdevRules = true;
      enableZram = true;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixdeck"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    networkmanager = {
      enable = true;
      dns = "dnsmasq";
      settings = {
        "global-dns-domain-*" = {
          "servers" = "1.1.1.1,1.0.0.1,2606:4700:4700::1111,2606:4700:4700::1001";
        };
      };
      ensureProfiles.profiles = {
        "Ethernet Connection" = {
          connection.type = "ethernet";
          connection.id = "Ethernet Connection";
          connection.interface-name = "enp4s0f3u1";
          connection.autoconnect = true;
          ipv4.method = "manual";
          ipv4.addresses = "10.0.0.184";
          ipv4.gateway = "10.0.0.1";
          ipv4.ignore-auto-dns = true;
        };
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.tailscale.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.luke = {
    isNormalUser = true;
    description = "Luke Wriglesworth";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    home = "/home/luke";
  };

  # Install firefox.
  programs.zsh.enable = true;
  programs.ssh = {
    startAgent = true;
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = ["freeimage-3.18.0-unstable-2024-04-18"];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    steamdeck-firmware
    jupiter-dock-updater-bin
    moonlight-qt
    git
    lazygit
    gh
    home-manager
    nh
    prismlauncher
    pegasus-frontend
    mgba
    rtorrent
    links2
    inputs.zen-browser.packages."${system}".twilight
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
