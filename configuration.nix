# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgs-unstable, pkgs-custom, ... }:

{
	imports =
	[ # Include the results of the hardware scan.
	./hardware-configuration.nix
	./sys/desktop_disks.nix 
	./sys/gnome.nix 
	#./sys/hyprland.nix #TODO: test this out
	];

	config = {
		hardware.enableAllFirmware = true;

		boot.loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};

		networking = {
			hostName = "vultur";
			networkmanager.enable = true;
			nameservers = [ "8.8.8.8" "8.8.4.4"];
		};

		time.timeZone = "America/New_York";

		i18n.defaultLocale = "en_US.UTF-8";
		console = {
			font = "Lat2-Terminus16";
			#keyMap = "us";
			useXkbConfig = true; # use xkb.options in tty.
		};


		# Define a user account. Don't forget to set a password with ‘passwd’.
		users.users.edrick = {
			isNormalUser = true;
			extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
			packages = with pkgs; [
			tree
			];
		};

		nix.settings.experimental-features = [ "nix-command" "flakes"];

		nixpkgs.config.allowUnfree = true;

		environment.systemPackages = with pkgs; [
		#Sys level packages that all sytems should have
		wget
		git
		git-filter-repo
		git-lfs

		#these dev tools should be installed with a dev shell flake

		btop
		unzip

		#auto disk mounting and other disk utils
		usbutils
		udisks
		udiskie
		gvfs

		upower
		bluez
		wireplumber

		vulkan-loader
		vulkan-tools
		vulkan-validation-layers
		vulkan-extension-layer
		mesa

		mlocate

		] ++

		(with pkgs-unstable; [
		neovim
		]);

		users.groups.mlocate = {};
		programs.steam.enable = true;


		#setup graphics
		hardware.graphics = {
			enable = true;
		};

		hardware.bluetooth.enable = true;

		# Enable sound.
		services.pipewire = {
			enable = true;
			audio.enable = true;
			pulse.enable = true;
			alsa.enable = true;
			wireplumber.enable = true;
		};

		services.upower.enable = true;
		services.blueman.enable = true;


		# Enable the OpenSSH daemon.
		services.openssh.enable = true;

		#file mounting services
		services.gvfs.enable = true;
		services.udisks2.enable = true;

		# Some programs need SUID wrappers, can be configured further or are
		# started in user sessions.
		programs.mtr.enable = true;
		programs.gnupg.agent = {
			enable = true;
			enableSSHSupport = true;
		};



		nix.settings.auto-optimise-store = true;
		nix.gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-generations +5";
		};

		swapDevices = [ { device = "/swapfile"; size = 16 * 1024; } ];

		system.stateVersion = "25.11"; # Did you read the comment?
	};


}

