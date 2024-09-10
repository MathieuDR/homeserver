{
  inputs,
  pkgs,
  lib,
  ...
}: {
  nix = {
    settings = {
      experimental-features = lib.mkDefault "nix-command flakes";
      trusted-users = ["root" "@wheel"];
      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
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

  services.xserver.enable = false;
  # No GPU, from wiki
  # services.xserver = {
  #   enable = false;
  #   displayManager.lightdm.enable = false;
  #   desktopManager.gnome.enable = false;
  #   # videoDrivers = ["fbdev"];
  # };

  # No audio
  sound.enable = false;
  hardware.pulseaudio.enable = false;
}
