{
  pkgs,
  config,
  lib,
  ...
}: {
  #TODO: Copied from hetzner server, I imagine I don't need this.
  # Maybe the disk config
  # imports = [
  #   (modulesPath + "/installer/scan/not-detected.nix")
  #   (modulesPath + "/profiles/qemu-guest.nix")
  #   ./disk-config.nix
  # ];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    loader = {
      generic-extlinux-compatible.enable = lib.mkDefault true;
      grub.enable = lib.mkDefault false;
    };
  };

  nix.settings = {
    experimental-features = lib.mkDefault "nix-command flakes";
    trusted-users = ["root" "@wheel"];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    (builtins.readFile ../secrets/id_rsa.pub)
  ];

  # From wiki: https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_4
  hardware = {
    raspberry-pi."4" = {
      audio.enable = false;
      apply-overlays-dtmerge.enable = true;
    };
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  # No GPU, from wiki
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.gnome.enable = true;
    videoDrivers = ["fbdev"];
  };

  # No audio
  sound.enable = false;
  hardware.pulseaudio.enable = false;
}
