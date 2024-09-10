{config, ...}: {
  _file = ./restic.nix;

  age.secrets = {
    "restic/env".file = ../secrets/restic/env.age;
    "restic/repo".file = ../secrets/restic/repo.age;
    "restic/password".file = ../secrets/restic/password.age;
  };

  services.restic.backups.b2 = {
    # We want to init our repo
    initialize = true;

    timerConfig = {
      OnCalendar = "00:05";
      # This will make sure it ran, even when the trigger was missed.
      Persistent = true;
    };

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
    ];

    # Use our secrets
    environmentFile = config.age.secrets."restic/env".path;
    repositoryFile = config.age.secrets."restic/repo".path;
    passwordFile = config.age.secrets."restic/password".path;

    createWrapper = true;
  };
}
