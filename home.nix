{ lib, config, pkgs,pkgs-unstable,pkgs-custom, ... }:

{
# Home Manager needs a bit of information about you and the paths it should
# manage.
	home.username = "edrick";
	home.homeDirectory = "/home/edrick";

# This value determines the Home Manager release that your configuration is
# compatible with. This helps avoid breakage when a new Home Manager release
# introduces backwards incompatible changes.
#
# You should not change this value, even if you update Home Manager. If you do
# want to update the value, then make sure to first check the Home Manager
# release notes.
	home.stateVersion = "25.11"; # Please read the comment before changing.
	nixpkgs.config.allowUnfree = true;


# The home.packages option allows you to install Nix packages into your
# environment.
	home.packages = with pkgs; [
		        google-chrome
			spotify
			vesktop

			gnumake
			gcc
			binutils
			


#lsp
			nil
			clang-tools

			libreoffice

			v4l-utils
			libva-utils


# # It is sometimes useful to fine-tune packages, for example, by applying
# # overrides. You can do that directly here, just don't forget the
# # parentheses. Maybe you want to install Nerd Fonts with a limited number of
# # fonts?
# (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

# # You can also create simple shell scripts directly inside your
# # configuration. For example, this adds a command 'my-hello' to your
# # environment:
# (pkgs.writeShellScriptBin "my-hello" ''
#   echo "Hello, ${config.home.username}!"
# '')
			] ++

			(with pkgs-unstable; [
			 orca-slicer
			 tree-sitter
			 ripgrep
			 meld
			 gitg
			 gdb
			 cgdb
			]) ++

			(with pkgs-custom; [
			]);


# Home Manager is pretty good at managing dotfiles. The primary way to manage
# plain files is through 'home.file'.
	home.file = {

	".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "/home/edrick/git/home-config/.gitconfig";
	".gdbinit".source = config.lib.file.mkOutOfStoreSymlink "/home/edrick/git/home-config/.gdbinit";


# # Building this configuration will create a copy of 'dotfiles/screenrc' in
# # the Nix store. Activating the configuration will then make '~/.screenrc' a
# # symlink to the Nix store copy.
# ".screenrc".source = dotfiles/screenrc;

# # You can also set the file content immediately.
# ".gradle/gradle.properties".text = ''
#   org.gradle.console=verbose
#   org.gradle.daemon.idletimeout=3600000
# '';
	};


# Home Manager can also manage your environment variables through
# 'home.sessionVariables'. These will be explicitly sourced when using a
# shell provided by Home Manager. If you don't want to manage your shell
# through Home Manager then you have to manually source 'hm-session-vars.sh'
# located at either
#
#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  /etc/profiles/per-user/edrick/etc/profile.d/hm-session-vars.sh

	home.activation.pullDotfiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
		DOTFILES_DIR="$HOME/git/home-config"

		if [ -d "$DOTFILES_DIR/.git" ]; then
			echo "Updating dotfiles repo..."
				/run/current-system/sw/bin/git -C "$DOTFILES_DIR" pull --rebase
				elif [ ! -d "$DOTFILES_DIR" ]; then
				echo "Cloning dotfiles repo..."
				/run/current-system/sw/bin/git clone https://github.com/edrickhong/home-config.git "$DOTFILES_DIR"
		else
			echo "Dotfiles directory exists but is not a git repo. Skipping."
				fi
				'';


	home.sessionVariables = {
		EDITOR = "nvim";
	};

	home.sessionPath = ["$HOME/bin"];


# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;

	programs.bash = {
		enable = true;

		shellAliases = {
			vim = "nvim";
			nx-switch = "pushd ~/.config/nixos && sudo nixos-rebuild switch --flake .#edrick && popd";
			hm-switch = "pushd ~/.config/nixos && home-manager switch --flake .#edrick && popd";
			nx-init-py = "nix-init-py.sh";
			nx-dev = "nix develop";
		};

	};


}
