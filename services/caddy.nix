{...}: {
  services.caddy = {
    enable = true;
    email = "caddy@deraedt.dev";
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
