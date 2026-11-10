

{...}:

{
	imports = [
		./home.nix
	];

	programs.bash = {
		shellAliases = {
			hm-switch = "pushd ~/.config/nixos && home-manager switch --flake .#edrick@noctua && popd";
		};

	};


}
