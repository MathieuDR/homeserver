{...}: {
  _file = ./adguard.nix;
  networking.firewall = {
    allowedTCPPorts = [3000 53];
    allowedUDPPorts = [53];
  };

  services.adguardhome = {
    enable = true;
    allowDHCP = true;
    host = "127.0.0.1";
    port = 3000;
    settings = {
      bind_hosts = ["0.0.0.0"];
      port = 53;
      # Cloudflare - Google
      upstream_dns = ["1.1.1.1" "8.8.8.8"];
      fallback_dns = ["1.0.0.1" "4.4.4.4"];
      cache_size = 536870912;
      cache_ttl_min = 600;
      cache_ttl_max = 86400;
      cache_optimistic = true;
      filtering = {
        filtering_enabled = true;
        rewrites = [
          {
            domain = "adguard.i.deraedt.dev";
            answer = "192.168.178.201";
          }
          {
            domain = "*.i.deraedt.dev";
            answer = "192.168.178.210";
          }
        ];
      };
      filters = [
        {
          name = "hagezi multi normal";
          enabled = true;
          url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/multi.txt";
        }
        {
          name = "hagezi tif";
          enabled = true;
          url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.txt";
        }
      ];
    };
  };

  services.caddy.virtualHosts."adguard.i.deraedt.dev" = {
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:3000
    '';
  };
}
