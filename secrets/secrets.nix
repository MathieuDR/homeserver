let
  homeserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPCMMS1A1PBi7c9rKHnVahK4/ytgsoACNvm8W03gfk3";
  local_pc = builtins.readFile ./id_rsa.pub;
  all_recipients = [homeserver local_pc];
in {
  # Restic
  "restic/env.age".publicKeys = all_recipients;
  "restic/repo.age".publicKeys = all_recipients;
  "restic/password.age".publicKeys = all_recipients;

  # Paperless
  "paperless/env.age".publicKeys = all_recipients;
}
