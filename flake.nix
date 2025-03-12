{
  description = "Luke's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
    };
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{nixpkgs, nix-darwin, nixos-hardware, chaotic, ... }: {
    # System Configurations
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./config/nixos/configuration.nix
          ./config/nixos/hyprland.nix
          ./config/nixos/hardware-configuration.nix
          chaotic.nixosModules.default
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-pc-ssd
        ];
      };
    };
    darwinConfigurations = {
      darwin = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./config/darwin/darwin.nix 
        ];
      };
    };

    # Home Manager
    homeConfigurations = {
      "luke@nixos" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        extraSpecialArgs = { inherit inputs; };
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
      "lukewriglesworth@Lukes-MacBook-Pro" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "aarch64-darwin"; };
          extraSpecialArgs = { inherit inputs; };
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
