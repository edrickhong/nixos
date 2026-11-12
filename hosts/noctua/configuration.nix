
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgs-unstable, pkgs-custom, ... }:

{
	imports =
	[ # Include the results of the hardware scan.
	./hardware-configuration.nix
	../../de/gnome.nix 
	];

	config = {
		hardware.enableAllFirmware = true;

		boot.loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};

		systemd.sleep.settings.Sleep = {
			AllowSuspend = "no";
			AllowHibernation = "no";
			AllowHybridSleep = "no";
			AllowSuspendThenHibernate = "no";
		};

		networking = {
			hostName = "noctua";
			networkmanager.enable = true;
			nameservers = [ "8.8.8.8" "8.8.4.4"];
			firewall.allowedTCPPorts = [8080]; #8080 for qbittorrent
		};

		time.timeZone = "America/New_York";

		i18n.defaultLocale = "en_US.UTF-8";
		console = {
			font = "Lat2-Terminus16";
			useXkbConfig = true; # use xkb.options in tty.
		};


		# Define a user account. Don't forget to set a password with ‘passwd’.
		users.groups.media = {};
		users.users.edrick = {
			isNormalUser = true;
			extraGroups = [ "wheel" "networkmanager" "media"]; # Enable ‘sudo’ for the user.
			packages = with pkgs; [
			tree
			];
		};

		users.users.gaming = {
			isNormalUser = true;
			description = "Visual Gaming User";
			extraGroups = [ "video" "render" "audio" "input" "uinput"]; # Enable ‘sudo’ for the user.
		};
		users.users.jellyfin.extraGroups = ["media" "video" "render"];
		users.users.qbittorrent.extraGroups = ["media"];

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
			enable32Bit = true;
		};

		hardware.nvidia = {
			modesetting.enable = true;
			open = false;
			nvidiaSettings = true;
			package = config.boot.kernelPackages.nvidiaPackages.stable; # use stable nvidia drivers
			nvidiaPersistenced = true;
			};

		hardware.bluetooth.enable = true;

		services.prowlarr = {
			enable = true;
			openFirewall = true;
		};

		services.qbittorrent = {
			enable = true;
			webuiPort = 8080;
		};

		services.jellyfin = {
			enable = true;
			openFirewall = true;
		};

		services.sunshine = {
			enable = true;
			autoStart = true;
			capSysAdmin = true;
			openFirewall = true;
		};

		services.xserver.videoDrivers = ["nvidia"];

		services.avahi = {
			enable = true;
			nssmdns4 = true;
			publish = {
				enable = true;
				addresses = true;
			};
		};

		#login to gaming user
		services.displayManager = {
			autoLogin = {
				enable = true;
				user = "gaming";
			};
		};

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

		#prevent system level suspension
		services.logind.settings.Login = {
			IdleAction = "ignore";
			HandleLidSwitch = "ignore";
		};

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

		#this tops gaming user from powering off
		security.polkit.enable = true;
		security.polkit.extraConfig = ''
		polkit.addRule(function(action, subject){
			const blocked = [
				"org.freedesktop.login1.power-off",
				"org.freedesktop.login1.power-off-multiple-sessions",
				"org.freedesktop.login1.reboot",
				"org.freedesktop.login1.reboot-multiple-sessions",
				"org.freedesktop.login1.suspend",
				"org.freedesktop.login1.suspend-multiple-sessions",
				"org.freedesktop.login1.hibernate",
				"org.freedesktop.login1.hibernate-multiple-sessions",
			];

			if(subject.user == "gaming" && blocked.indexOf(action.id) !== -1){
				polkit.log("POWER CHECK: usr=" + subject.user + " action=" + action.id);
				return polkit.Result.NO;
			}
		}
		);
		'';

		swapDevices = [ { device = "/swapfile"; size = 16 * 1024; } ];

		system.stateVersion = "26.05"; # Did you read the comment?
	};


}

