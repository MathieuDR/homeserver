{
  config,
  pkgs,
  ...
}: let
  port = 29818;

  #NOTE: This is the default
  dataDir = "/var/lib/paperless";
  mediaDir = "${dataDir}/media";
in {
  _file = ./paperless-ngx.nix;

  age.secrets = {
    "paperless/env".file = ../secrets/paperless/env.age;
  };

  # environment.systemPackages = with pkgs; [
  #   kdePackages.zxing-cpp
  # ];

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
      #OCR
      PAPERLESS_OCR_PAGES = 1;
      # PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_LANGUAGE = "nld+deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
        invalidate_digital_signatures = true;
      };

      #OFFICE
      PAPERLESS_TIKA_ENABLED = true;
      PAPERLESS_TIKA_ENDPOINT = "http://127.0.0.1:29820";
      PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://127.0.0.1:29819";

      #BARCODES
      # PAPERLESS_CONSUMER_ENABLE_BARCODES = true;
      # PAPERLESS_CONSUMER_ENABLE_ASN_BARCODE = true;
      # PAPERLESS_CONSUMER_BARCODE_MAX_PAGES = 1;
    };
  };

  services.caddy.virtualHosts."paperless.local" = {
    serverAliases = ["archive.local" "documents.local"];
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:${builtins.toString port}
    '';
  };
}
