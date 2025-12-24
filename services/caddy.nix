{...}: {
  services.caddy = {
    enable = true;
    email = "caddy@deraedt.dev";

    # virtualHosts."ca.i.deraedt.dev" = {
    #   extraConfig = ''
    #     tls internal
    #     root * /var/lib/caddy/.local/share/caddy/pki/authorities/local
    #     file_server
    #   '';
    # };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
