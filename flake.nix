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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/master";
    nixpkgs-pinned.url = "github:nixos/nixpkgs/551e707f257cffeef2c0af17b7e3384478c00ede";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixos-artwork = {
      url = "github:nixos/nixos-artwork/master";
      flake = false;
    };
    jovian.url = "github:jovian-experiments/jovian-nixos";
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    jovian,
    chaotic,
    homebrew-core,
    homebrew-cask,
    nixos-hardware,
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
          ./hosts/nixos/configuration.nix
          ./hosts/nixos/hardware-configuration.nix
          ./hosts/nixos/packages.nix
          ./nixosModules
          chaotic.nixosModules.default
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd
        ];
      };
      nixdeck = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {inherit inputs system;};
        modules = [
          ./hosts/steamdeck/configuration.nix
          ./hosts/steamdeck/hardware-configuration.nix
          ./nixosModules
          jovian.nixosModules.default
        ];
      };
    };
    darwinConfigurations = {
      Lukes-MacBook-Pro = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/darwin/darwin.nix
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
          ./homeManagerModules
          ./hosts/nixos/home.nix
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
          ./homeManagerModules
          ./hosts/steamdeck/home.nix
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
          ./homeManagerModules
          ./hosts/darwin/home.nix
        ];
      };
    };
  };
}
