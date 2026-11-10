
{ config, pkgs, pkgs-custom, ... }:

{
        services.xserver.enable = true;
        services.displayManager.gdm.enable = true;
        services.desktopManager.gnome.enable = true;

	environment.systemPackages = with pkgs; [
		wl-clipboard
		xdg-desktop-portal
	] ++

	(with pkgs-custom; [
	]);

	programs.dconf.enable = true; # XDG portals stuff
		xdg.portal = {
			enable = true;
		};
}
