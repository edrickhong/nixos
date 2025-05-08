{
	description = "corvus";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager.url = "github:nix-community/home-manager/release-24.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		ags.url = "github:Aylur/ags";
		hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
	};

	outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ags, hyprpanel, ...}: 
		let lib = nixpkgs.lib;
	system = "x86_64-linux";
	pkgs = nixpkgs.legacyPackages.${system};
	pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

	pkgs-custom = {
		ags = ags.packages.${system}.default;
		hyprpanel = hyprpanel.packages.${system}.default;
	};
	in {

		nixosConfigurations = {
			corvus = lib.nixosSystem {
				inherit system;
				modules = [
					./configuration.nix
				];

				specialArgs = {
					inherit pkgs-unstable;
					inherit pkgs-custom;
				};

			};
		};


		homeConfigurations = {
			corvus = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [
					./home.nix
				];

				extraSpecialArgs = {
					inherit pkgs-unstable;
					inherit pkgs-custom;
				};
			};
		};




	};
}

