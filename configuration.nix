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

	system.activationScripts.fix-efi-boot-order.text = ''
  		/run/current-system/sw/bin/efibootmgr -o 0001,0000
		'';

	networking.hostName = "corvus"; # Define your hostname.
	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

	time.timeZone = "America/New_York";

	i18n.defaultLocale = "en_US.UTF-8";
	console = {
		font = "Lat2-Terminus16";
		#keyMap = "us";
		useXkbConfig = true; # use xkb.options in tty.
	};


	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.corvus = {
		isNormalUser = true;
		shell = pkgs.zsh;
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
			zsh

			vulkan-loader
			vulkan-tools
			vulkan-validation-layers
			vulkan-extension-layer
			mesa
			mesa.drivers


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

	environment.shells = with pkgs; [zsh];
	programs.zsh.enable = true;


	#setup graphics
	hardware.graphics = {
		enable = true;
		driSupport32Bit = true;
	};

	# Enable sound.
	services.pipewire = {
		enable = true;
		audio.enable = true;
		pulse.enable = true;
		alsa.enable = true;
	};
	programs.hyprland.enable = true;


	services.greetd.enable = true;
	services.greetd.settings.default_session = {
		command = "tuigreet --time --asterisks --user-menu --cmd Hyprland";
		user = "greeter";
	};




	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	programs.mtr.enable = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};

	# Enable the OpenSSH daemon.
	services.openssh.enable = true;

	nix.settings.auto-optimise-store = true;
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-generations +5";
	};

	swapDevices = [ { device = "/var/swap/swapfile";} ];

	system.stateVersion = "24.11"; # Did you read the comment?

}

