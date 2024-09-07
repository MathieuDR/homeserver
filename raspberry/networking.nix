{config, ...}: {
  age.secrets = {
    "network/env".file = ../secrets/network/env.age;
  };

  networking = {
    #TODO: Get hostname from config?
    hostName = "homeserver";
    domain = "home. is ou server";
    networkmanager.enable = false;
    interfaces."wlan0".useDHCP = true;
    wireless = {
      interfaces = ["wlan0"];
      enable = true;
      environmentFile = config.age.secrets."network/env".path;
      networks = {
        BeeConnected.psk = "@BEE_PSK@";
      };
    };
  };
}
