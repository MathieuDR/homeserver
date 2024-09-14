{...}: {
  _file = ./adguard.nix;
  networking.firewall = {
    allowedTCPPorts = [3000 53];
    allowedUDPPorts = [67 53];
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
            domain = "*.local";
            answer = "192.168.2.12";
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
      dhcp = {
        enabled = true;
        interface_name = "end0";
        dhcpv4 = {
          gateway_ip = "192.168.2.1"; # router
          range_start = "192.168.2.30";
          range_end = "192.168.2.230";
          subnet_mask = "255.255.255.0";
          lease_duration = 181440; # 3 weeks
        };
      };
    };
  };

  services.caddy.virtualHosts."adguardhome.local" = {
    serverAliases = ["adguardhome.local" "adguard.local" "addblock.local"];
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:3000
    '';
  };
}
