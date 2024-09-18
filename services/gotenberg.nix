{
  inputs,
  pkgs,
  ...
}: let
  port = 29819;
in {
  # Ensure the package is from unstable
  nixpkgs.overlays = [
    (final: prev: {
      gotenberg = pkgs.unstable.gotenberg.overrideAttrs {
        meta.mainProgram = "gotenberg";
      };
    })
  ];

  # Import the module definition from unstable
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/misc/gotenberg.nix"
  ];

  # Configure the gotenberg service
  services.gotenberg = {
    enable = true;
    port = port;
    package = pkgs.gotenberg;
  };
}
