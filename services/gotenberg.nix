{...}: let
  port = 29819;
in {
  services.gotenberg = {
    enable = true;
    port = port;
  };
}
