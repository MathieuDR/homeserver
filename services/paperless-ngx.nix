{config, ...}: {
  age.secrets = {
    "paperless/env".file = ../../secrets/paperless/env.age;
  };

  services.paperless = {
    enable = true;
    passwordFile = config.age.secrets."paperless/env".path;
    consumptionDirIsPublic = true;
    address = "archive.local";

    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };
}
