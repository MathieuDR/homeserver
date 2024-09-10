{config, ...}: let
  port = 29818;
in {
  _file = ./paperless-ngx.nix;

  age.secrets = {
    "paperless/env".file = ../secrets/paperless/env.age;
  };

  networking.firewall.allowedTCPPorts = [port];

  services.paperless = {
    enable = true;
    passwordFile = config.age.secrets."paperless/env".path;
    consumptionDirIsPublic = true;
    port = port;
    address = "0.0.0.0";

    settings = {
      PAPERLESS_OCR_PAGES = 1;
      PAPERLESS_OCR_LANGUAGE = "nld+deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };
}
