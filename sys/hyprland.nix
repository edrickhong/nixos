
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
			kdePackages.polkit-kde-agent-1
			networkmanagerapplet
			rofi-wayland
			yazi
			nautilus
			nautilus-open-any-terminal
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
	
	programs.nautilus-open-any-terminal = {
		enable = true;
		terminal = "ghostty";
	};

	services.greetd.enable = true;
	services.greetd.settings.default_session = {
		command = "tuigreet --time --asterisks --user-menu --cmd Hyprland";
		user = "greeter";
	};
}
