# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgs-unstable, pkgs-custom, ... }:

{
	imports =
	[ # Include the results of the hardware scan.
	./hardware-configuration.nix
	./sys/hyprland.nix
	./sys/corvus_disks.nix
	];

	options = {
		ed.WM = lib.mkOption {
			type = lib.types.str;
			default = "wayland";
		};
	};

	config = {
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

		boot.supportedFilesystems = [ "btrfs" "ntfs" ];

		system.activationScripts.fix-efi-boot-order.text = ''
		/run/current-system/sw/bin/efibootmgr -o 0002,0000
		'';

		networking = {
			hostName = "corvus";
			interfaces.enp10s0.useDHCP = true;

			networkmanager = {
				enable = true;
				dns = "none";

				#connectionConfig = {
					#"connection.autoconnect" = "true";
					#"ip4.never-default" = "true";
				#};
			};


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
		users.users.corvus = {
			isNormalUser = true;
			shell = pkgs.zsh;
			extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
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
		wget
		git
		git-filter-repo
		git-lfs

		#these dev tools should be installed with a dev shell flake
		#cmake
		#ninja
		#clang
		#gcc

		btop
		unzip
		zsh

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
		]) ++

		(if(config.ed.WM == "wayland") then [
			libinput
			wl-clipboard
			xdg-desktop-portal
		] else []);

		users.groups.mlocate = {};

		environment.shells = with pkgs; [zsh];
		programs.zsh.enable = true;


		programs.steam.enable = true;


		#setup graphics
		hardware.graphics = {
			enable = true;
		};

		hardware.bluetooth.enable = true;

		virtualisation.docker.enable = true;

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

		programs.dconf.enable = true; # XDG portals stuff
			xdg.portal = {
				enable = true;
				extraPortals = [
					pkgs.xdg-desktop-portal-wlr
					pkgs.xdg-desktop-portal-gtk
				];
			};


		nix.settings.auto-optimise-store = true;
		nix.gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-generations +5";
		};

		swapDevices = [ { device = "/var/swap/swapfile";} ];

		system.stateVersion = "24.11"; # Did you read the comment?
	};


}

