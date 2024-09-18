{pkgs, ...}: let
  port = 29819;
in {
  # Ensure the package is from unstable
  nixpkgs.overlays = [
    (final: prev: {
      gotenberg = pkgs.unstable.gotenberg;
    })
  ];

  # Import the module definition from unstable
  imports = [
    (pkgs.unstable.path + "/nixos/modules/services/misc/gotenberg.nix")
  ];

  # Configure the gotenberg service
  services.gotenberg = {
    enable = true;
    port = port;
    package = pkgs.gotenberg;
  };
}
