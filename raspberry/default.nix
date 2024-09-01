{config, ...}: {
  imports = [
    ./configuration.nix
    ./networking.nix
    ./variable.nix
    ./GPIO.nix
    ./disk.nix
  ];

  system.stateVersion = "24.05";
}
