# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		];

	hardware.enableAllFirmware = true;

	boot.loader = {
		efi.canTouchEfiVariables = true;

		grub = {
			enable = true;
			efiSupport = true;
			device = "nodev";  # EFI system
			useOSProber = true;
		};
	};

	networking.hostName = "corvus"; # Define your hostname.
	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

	time.timeZone = "America/New_York";

	i18n.defaultLocale = "en_US.UTF-8";
	console = {
		font = "Lat2-Terminus16";
		#keyMap = "us";
		useXkbConfig = true; # use xkb.options in tty.
	};

	environment.shells = with pkgs; [zsh];

	# Enable sound.
	services.pipewire = {
		enable = true;
		audio.enable = true;
		pulse.enable = true;
		alsa.enable = true;
	};

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.corvus = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
			packages = with pkgs; [
			tree
			];
	};

	nix.settings.experimental-features = [ "nix-command" "flakes"];

	nixpkgs.config.allowUnfree = true;

	environment.systemPackages = with pkgs; [
	#Sys level packages that all sytems should have
			os-prober
			grub2
			efibootmgr
			neovim
			wget
			git
			git-filter-repo
			cmake
			ninja
			clang
			gcc
			btop
			unzip
			mesa
			zsh


	#wm level packages (WAYLAND)
			wl-clipboard
			xdg-desktop-portal
			xdg-desktop-portal-hyprland
			qt5.qtwayland
			qt6.qtwayland
			hyprland
			swaynotificationcenter # notification daemon
			libnotify
			polkit-kde-agent
			networkmanagerapplet
			ghostty
			waybar
			rofi-wayland
			yazi
			nautilus
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



	nix.settings.auto-optimise-store = true;
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-generations +5";
	};

	swapDevices = [ { device = "/var/swap/swapfile";} ];

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

	# Enable the OpenSSH daemon.
	services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# Copy the NixOS configuration file and link it from the resulting system
# (/run/current-system/configuration.nix). This is useful in case you
# accidentally delete configuration.nix.
# system.copySystemConfiguration = true;

# This option defines the first version of NixOS you have installed on this particular machine,
# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
#
# Most users should NEVER change this value after the initial install, for any reason,
# even if you've upgraded your system to a new NixOS release.
#
# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
# to actually do that.
#
# This value being lower than the current NixOS release does NOT mean your system is
# out of date, out of support, or vulnerable.
#
# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
# and migrated your data accordingly.
#
# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
	system.stateVersion = "24.11"; # Did you read the comment?

}

