{config, ...}: let
  port = 29818;

  #NOTE: This is the default
  dataDir = "/var/lib/paperless";
  mediaDir = "${dataDir}/media";
in {
  _file = ./paperless-ngx.nix;

  age.secrets = {
    "paperless/env".file = ../secrets/paperless/env.age;
  };

  networking.firewall.allowedTCPPorts = [port];
  services.restic.backups.b2.paths = [
    mediaDir
    "${dataDir}/db.sqlite3"
    "${dataDir}/celerybeat-schedule.db"
    "${dataDir}/index"
    "${dataDir}/nixos-paperless-secret-key"
    "${dataDir}/superuser-state"
  ];

  services.paperless = {
    enable = true;
    passwordFile = config.age.secrets."paperless/env".path;
    consumptionDirIsPublic = true;
    port = port;
    address = "127.0.0.1";
    dataDir = dataDir;
    mediaDir = mediaDir;

    settings = {
      PAPERLESS_OCR_PAGES = 1;
      PAPERLESS_OCR_LANGUAGE = "nld+deu+eng";
      # PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };

  services.caddy.virtualHosts."paperless.home.arpa" = {
    serverAliases = ["archive.home.arpa" "documents.home.arpa"];
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:${builtins.toString port}
    '';
  };
}
