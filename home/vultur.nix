{ pkgs,pkgs-unstable,pkgs-custom, ... }:

{
	imports = [
		./home.nix
	];


	home.packages = with pkgs; [
		        google-chrome
			spotify
			vesktop

			libreoffice

			] ++

			(with pkgs-unstable; [
			 orca-slicer
			 meld
			]) ++

			(with pkgs-custom; [
				raddebugger
			]);


	programs.bash = {
		shellAliases = {
			hm-switch = "pushd ~/.config/nixos && home-manager switch --flake .#edrick@vultur && popd";
		};

	};


}
