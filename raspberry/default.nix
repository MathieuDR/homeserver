{config, ...}: {
  imports = [
    ./configuration.nix
    ./networking.nix
    ./variable.nix
    ./GPIO.nix
    ./sd.nix
  ];

  system.stateVersion = "24.05";
}
