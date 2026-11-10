{ config, pkgs, pkgs-custom, ... }:

{
	boot.supportedFilesystems = [ "ext4" "ntfs" ];

	systemd.tmpfiles.rules = [
	"d /home/edrick/nvme 0755 edrick users - -"
	"d /home/edrick/storage 0755 edrick users - -"
	];

	fileSystems."/home/edrick/nvme" = {
		device = "UUID=C2A88F77A88F68AD";
		fsType = "ntfs3";
		options = [
			"nofail"
			"x-systemd.automount"
			"uid=1000"
			"gid=1000"
			"dmask=022"
			"fmask=022"
			"exec"
		];
	};

	fileSystems."/home/edrick/storage" = {
		device = "UUID=348489EB8489AFC2";
		fsType = "ntfs3";
		options = [
			"nofail"
			"x-systemd.automount"
			"uid=1000"
			"gid=1000"
			"dmask=022"
			"fmask=022"
			"exec"
		];
	};
}

