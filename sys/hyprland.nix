
{ config, pkgs, pkgs-custom, ... }:

{
	environment.systemPackages = with pkgs; [
	#WAYLAND
	#HYPRLAND
			xdg-desktop-portal-hyprland
			qt5.qtwayland
			qt6.qtwayland
			hyprland
			libnotify
			polkit-kde-agent
			networkmanagerapplet
			rofi-wayland
			yazi
			nautilus
			ghostty
			pavucontrol
			greetd.tuigreet  #login manager
			mpvpaper #wallpaper manager
			mpv
	] ++

	(with pkgs-custom; [
		hyprpanel
	]);

	ed.WM = "wayland";

	programs.hyprland.enable = true;

	services.greetd.enable = true;
	services.greetd.settings.default_session = {
		command = "tuigreet --time --asterisks --user-menu --cmd Hyprland";
		user = "greeter";
	};
}
