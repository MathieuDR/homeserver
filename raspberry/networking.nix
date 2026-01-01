{hostname, ...}: {
  _file = ./networking.nix;

  networking = {
    hostName = hostname;
    domain = "hpi.home.deraedt.dev";

    defaultGateway = "192.168.178.1";
    nameservers = ["94.140.14.14" "94.140.15.15"];

    interfaces.end0.ipv4.addresses = [
      {
        address = "192.168.178.201";
        prefixLength = 24;
      }
    ];

    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443];
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
}
