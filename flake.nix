{
	description = "edrick";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager.url = "github:nix-community/home-manager/release-26.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		#NOTE: we aren't using these anymore but we will leave this here as an example
		#ags.url = "github:Aylur/ags";
		#hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
	};

	#outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ags, hyprpanel, ...}: 
	outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ...}: 
		let lib = nixpkgs.lib;
	system = "x86_64-linux";
	pkgs = nixpkgs.legacyPackages.${system};
	pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

	pkgs-custom = {
		#ags = ags.packages.${system}.default;
		#hyprpanel = hyprpanel.packages.${system}.default;
		raddebugger = pkgs.callPackage ./packages/raddbg.nix {};
	};
	in {

		nixosConfigurations = {
			edrick = lib.nixosSystem {
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
			edrick = home-manager.lib.homeManagerConfiguration {
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

