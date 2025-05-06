{
	description = "corvus";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager.url = "github:nix-community/home-manager/release-24.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ...}: 
		let lib = nixpkgs.lib;
	system = "x86_64-linux";
	pkgs = nixpkgs.legacyPackages.${system};
	pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
	in {

		nixosConfigurations = {
			corvus = lib.nixosSystem {
				inherit system;
				modules = [
					./configuration.nix
				];

				specialArgs = {
					inherit pkgs-unstable;
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
				};
			};
		};




	};
}

