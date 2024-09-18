{
  inputs,
  pkgs,
  ...
}: let
  port = 29820;
in {
  # Ensure the package is from unstable
  nixpkgs.overlays = [
    (final: prev: {
      tika = pkgs.unstable.tika;
    })
  ];

  # Import the module definition from unstable
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/search/tika.nix"
  ];

  # Configure the tika service
  services.tika = {
    enable = true;
    port = port;
    enableOCR = true;
    package = pkgs.tika;
  };
}
