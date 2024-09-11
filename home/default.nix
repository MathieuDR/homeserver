{username, ...}: {
  environment.enableAllTerminfo = true;
  security.sudo.wheelNeedsPassword = false;

  nix.settings.trusted-users = [username];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../secrets/id_rsa.pub)
    ];
  };

  home-manager.users.${username} = {
    imports = [
      ./configuration.nix
    ];
  };
}
