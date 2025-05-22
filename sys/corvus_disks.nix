{ config, pkgs, pkgs-custom, ... }:

{
	boot.supportedFilesystems = [ "btrfs" "ntfs" ];

	systemd.tmpfiles.rules = [
	"d /home/corvus/nvme 0755 corvus users - -"	
	"d /home/corvus/storage 0755 corvus users - -"	
	];

	fileSystems."/home/corvus/nvme" = {
		device = "UUID=C2A88F77A88F68AD";
		fsType = "ntfs-3g";
		options = [ "uid=1000" "gid=1000" "dmask=022" "fmask=022" "exec" "permissions" ];
	};


	fileSystems."/home/corvus/storage" = {
		device = "UUID=348489EB8489AFC2";
		fsType = "ntfs-3g";
		options = [ "uid=1000" "gid=1000" "dmask=022" "fmask=022" "exec" "permissions" ];
	};
}

