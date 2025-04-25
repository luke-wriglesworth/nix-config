{
  description = "Luke's NixOS configuration";
  inputs = {
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/master";
    nixpkgs-pinned.url = "github:nixos/nixpkgs/551e707f257cffeef2c0af17b7e3384478c00ede";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixos-artwork = {
      url = "github:nixos/nixos-artwork/master";
      flake = false;
    };
    jovian.url = "github:jovian-experiments/jovian-nixos";
    stylix.url = "github:danth/stylix/release-24.11";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      url = "github:viperMl/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lan-mouse = {
      url = "github:feschber/lan-mouse";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-pinned,
    nix-darwin,
    nix-homebrew,
    chaotic,
    jovian,
    homebrew-core,
    homebrew-cask,
    nixos-hardware,
    nix-minecraft,
    stylix,
    ...
  }: {
    # System Configurations
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs system;
          pkgs-pinned = import nixpkgs-pinned {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./config/nixos/configuration.nix
          ./config/nixos/hyprland.nix
          ./config/nixos/hardware-configuration.nix
          stylix.nixosModules.stylix
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-pc-ssd
          chaotic.nixosModules.default
          nix-minecraft.nixosModules.minecraft-servers
        ];
      };
      nixdeck = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linu";
        specialArgs = {inherit inputs system;};
        modules = [
          ./config/steamdeck/configuration.nix
          ./config/steamdeck/hardware-configuration.nix
        ];
      };
    };
    darwinConfigurations = {
      Lukes-MacBook-Pro = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./config/darwin/darwin.nix
          nix-homebrew.darwinModules.nix-homebrew
          stylix.darwinModules.stylix
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "lukewriglesworth";
              mutableTaps = false;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };
            };
          }
        ];
      };
    };

    # Home Manager
    homeConfigurations = {
      "luke@nixos" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        extraSpecialArgs = {inherit inputs;};
        modules = [
          {
            home.username = "luke";
            home.homeDirectory = "/home/luke";
            home.stateVersion = "24.11";
          }
          ./home/common/home.nix
          ./home/nixos/nixos.nix
        ];
      };
      "luke@nixdeck" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        extraSpecialArgs = {inherit inputs;};
        modules = [
          {
            home.username = "luke";
            home.homeDirectory = "/home/luke";
            home.stateVersion = "24.11";
          }
          ./home/common/home.nix
        ];
      };
      "lukewriglesworth@Lukes-MacBook-Pro" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "aarch64-darwin";};
        extraSpecialArgs = {inherit inputs;};
        modules = [
          {
            home.username = "lukewriglesworth";
            home.homeDirectory = "/Users/lukewriglesworth";
            home.stateVersion = "25.05";
          }
          ./home/common/home.nix
          ./home/darwin/darwin.nix
        ];
      };
    };
  };
}
