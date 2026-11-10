{ pkgs,pkgs-unstable,pkgs-custom, ... }:

{
	imports = [
		./home.nix
	];

	programs.bash = {
		shellAliases = {
			hm-switch = "pushd ~/.config/nixos && home-manager switch --flake .#edrick@noctua && popd";
			gaming-switch = "pushd ~/.config/nixos && nix build '.#homeConfigurations.\"gaming@noctua\".activationPackage' && sudo -u gaming -H \"$(readlink -f result)/activate\"&& rm result && popd";
		};

	};


}
