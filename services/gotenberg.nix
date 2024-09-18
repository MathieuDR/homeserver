{pkgs, ...}: let
  port = 29819;
in {
  # Use the unstable channel for the gotenberg service
  imports = [
    (pkgs.unstable.nixosModules.gotenberg)
  ];

  # Configure the gotenberg service
  services.gotenberg = {
    enable = true;
    port = port;
  };

  # Ensure the package is from unstable
  nixpkgs.overlays = [
    (final: prev: {
      gotenberg = pkgs.unstable.gotenberg;
    })
  ];
}
