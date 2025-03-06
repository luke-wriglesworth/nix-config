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

  outputs = inputs@{nixpkgs, nix-darwin, home-manager, nixos-hardware, chaotic, ... }: 
    {
    nixosConfigurations = {
      # amd64 nixos
      hyprland = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ 
          ./config/configuration.nix 
          ./config/hyprland.nix
          chaotic.nixosModules.default
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-pc-ssd
          home-manager.nixosModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users."luke" = import ./home/hyprland.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
    darwinConfigurations = {
      # aarch64 nix-darwin
      darwin = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [ 
          ./config/darwin.nix 
          home-manager.darwinModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users."lukewriglesworth" = import ./home/darwin.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
