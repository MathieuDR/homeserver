{hostname, ...}: {
  networking = {
    hostName = hostname;
    domain = "local";

    defaultGateway = "192.168.2.1";

    interfaces.end0.ipv4.addresses = [
      {
        address = "192.168.2.12";
        prefixLength = 24;
      }
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
}
