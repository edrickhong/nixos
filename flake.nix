{
	description = "NixOS & Home Manager config";

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
			vultur = lib.nixosSystem {
				inherit system;
				modules = [
					./hosts/vultur/configuration.nix
				];

				specialArgs = {
					inherit pkgs-unstable;
					inherit pkgs-custom;
				};

			};

			noctua = lib.nixosSystem {
				inherit system;
				modules = [
					./hosts/noctua/configuration.nix
				];

				specialArgs = {
					inherit pkgs-unstable;
					inherit pkgs-custom;
				};

			};
		};


		homeConfigurations = {
			"edrick@vultur" = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [
					./home/vultur.nix
				];

				extraSpecialArgs = {
					inherit pkgs-unstable;
					inherit pkgs-custom;
				};
			};

			"edrick@noctua" = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [
					./home/noctua.nix
				];

				extraSpecialArgs = {
					inherit pkgs-unstable;
					inherit pkgs-custom;
				};
			};
			"gaming@noctua" = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [
					./home/gaming.nix
				];

				extraSpecialArgs = {
					inherit pkgs-unstable;
					inherit pkgs-custom;
				};
			};
		};




	};
}

