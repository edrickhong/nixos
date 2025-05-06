
{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
	#WAYLAND
			libinput
			wl-clipboard
			xdg-desktop-portal
	#HYPRLAND
			xdg-desktop-portal-hyprland
			qt5.qtwayland
			qt6.qtwayland
			hyprland
			swaynotificationcenter # notification daemon
			libnotify
			polkit-kde-agent
			networkmanagerapplet
			waybar
			rofi-wayland
			yazi
			nautilus
			ghostty
			pavucontrol
			greetd.tuigreet  #login manager
			mpvpaper #wallpaper manager
			mpv
	];


	programs.hyprland.enable = true;

	services.greetd.enable = true;
	services.greetd.settings.default_session = {
		command = "tuigreet --time --asterisks --user-menu --cmd Hyprland";
		user = "greeter";
	};
}
