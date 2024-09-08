{
  pkgs,
  username,
  nix-index-database,
  inputs,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
    bat
    bottom
    curl
    du-dust
    fd
    fx
    git
    htop
    yq
    killall
    mosh
    procs
    sd
    tree
    unzip
    vim
    wget
    zip
    httpie
    gotop
  ];

  stable-packages = with pkgs; [
  ];
in {
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  home.stateVersion = "24.05";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
  };

  home.packages =
    stable-packages
    ++ unstable-packages
    ++ [
      (inputs.yvim.packages.aarch64-linux.default)
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;

    fzf.enable = true;
    broot.enable = true;
    gh.enable = true;
    jq.enable = true;
    ripgrep.enable = true;

    zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
      enableBashIntegration = true;
    };

    lsd = {
      enable = true;
      enableAliases = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      settings = builtins.fromJSON (builtins.readFile ./dotfiles/omp.json);
    };

    git = {
      enable = true;
      package = pkgs.unstable.git;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "mathieu@deraedt.dev";
      extraConfig = {
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };

    bash = {
      enable = true;
      historySize = 2500;
    };
  };
}
