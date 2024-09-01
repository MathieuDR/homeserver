{...}: {
  disko.devices = {
    disk = {
      sdcard = {
        type = "disk";
        device = "/dev/mmcblk0";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              start = "0";
              end = "256M";
              type = "0C00"; # FAT32 W95?
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              name = "root";
              start = "256M";
              end = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
