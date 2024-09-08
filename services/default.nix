{pkgs, ...}: let
  cd_script = pkgs.writeShellApplication {
    name = "deploy_image";
    text = ''
      set -euo pipefail

      if [ $# -ne 3 ]; then
          echo "Usage: $0 <IMAGE URL> <IMAGE TAG> <SERVICE> <TOKEN>"
          echo "Example: $0 ghcr.io/MathieuDR/foo latest podman-foo gh..."
          exit 1
      fi

      IMAGE_URL=''${1,,}
      IMAGE_TAG=$2
      SERVICE=$3

      # Pull the latest image
      sudo podman pull "''${IMAGE_URL}:''${IMAGE_TAG}"

      # Restart the systemd service
      sudo systemctl restart "''${SERVICE}"

      # Prune old images
      sudo podman image prune -af

      echo "Pulled image with tag ''${IMAGE_TAG} to update ''${SERVICE}"
    '';
  };
in {
  imports = [
  ];

  environment.systemPackages = [cd_script];
}
