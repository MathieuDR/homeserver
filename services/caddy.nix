{pkgs, ...}: {
  # home.packages = with pkgs; [
  #   nss
  #   nss.tools
  # ];

  environment.systemPackages = with pkgs; [
    nss
    nss.tools
  ];

  services.caddy = {
    enable = true;
    email = "caddy@deraedt.dev";
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
