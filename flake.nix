{
  description = "Luke's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    catppuccin.url = "github:catppuccin/nix";
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
    };
  };

  outputs = inputs@{nixpkgs, home-manager, plasma-manager, nixos-hardware, catppuccin, chaotic, ... }: 
    let
      username = "luke";
      system = "x86_64-linux";
    in
    {
    nixosConfigurations = {
      plasma = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./config/configuration.nix
          ./config/plasma.nix
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-pc-ssd
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	          home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
            home-manager.backupFileExtension = "backup";
            home-manager.users."${username}" = import ./home/plasma.nix;
          }
        ];
      };
      hyprland = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [ 
          ./config/configuration.nix 
          ./config/hyprland.nix
          chaotic.nixosModules.default
          catppuccin.nixosModules.catppuccin
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-pc-ssd
          home-manager.nixosModules.home-manager {
            #home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users."${username}" = import ./home/hyprland.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
