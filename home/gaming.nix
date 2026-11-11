
{ lib, config, pkgs,pkgs-unstable,pkgs-custom, ... }:

{
# Home Manager needs a bit of information about you and the paths it should
# manage.
	home.username = "gaming";
	home.homeDirectory = "/home/gaming";

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
	] ++

	(with pkgs-unstable; [
#orca-slicer
	]) ++

	(with pkgs-custom; [
#raddebugger
	]);



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
			nx-dev = "nix develop";
		};

	};

	#autolaunch steam in big picture mode
	xdg.configFile."autostart/steam.desktop".text = ''
	[Desktop Entry]
	Type=Application
	Name=Steam Big Picture
	Exec=${pkgs.steam}/bin/steam -bigpicture
	Terminal=false
	X-Gnome-Autostart-enabled=true
	'';

#gnome idle behavior
	dconf.enable = true;
	dconf.settings = {
	"org/gnome/desktop/session" = {
		idle-delay = lib.hm.gvariant.mkUint32 0;
		};

	"org/gnome/desktop/screensaver" = {
		lock-enabled = false;
		idle-activation-enabled = false;
		};

	"org/gnome/settings-daemon/plugins/power" = {
		sleep-inactive-ac-type = "nothing";
		sleep-inactive-battery-type = "nothing";
		};
	};


}
