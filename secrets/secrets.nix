let
  homeserver = "";
  local_pc = builtins.readFile ./id_rsa.pub;
  all_recipients = [homeserver local_pc];
in {
  # Restic
  "restic/env.age".publicKeys = all_recipients;
  "restic/repo.age".publicKeys = all_recipients;
  "restic/password.age".publicKeys = all_recipients;

  # Common
  "common/ghp.age".publicKeys = all_recipients;

  # Paperless
  "paperless/env.age".publicKeys = all_recipients;
}
