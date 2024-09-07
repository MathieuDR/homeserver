# Define constants
IP := "192.168.2.69"
USER := "root"
SSH_USER := "home"
FLAKE := ".#homeserver"

# Define the default recipe to list available commands
default:
    @just --list

# Wipes nixos, and puts new config on it. Also wipes the known host lines
wipe:
    @echo "Removing known host entries for {{IP}}"
    sed -i '/{{IP}}/d' ~/.ssh/known_hosts
    nix run github:nix-community/nixos-anywhere -- --flake {{FLAKE}} {{USER}}@{{IP}}

# Local Rebuild nixos, no wipe
rebuild-local:
    nixos-rebuild switch --flake {{FLAKE}}

# Rebuilds nixos, doesn't wipe
rebuild *args:
    @echo "use --option eval-cache false for no cache"
    nixos-rebuild switch --flake {{FLAKE}} --target-host {{USER}}@{{IP}} {{args}}

# Connects to the remote machine
connect:
    ssh {{SSH_USER}}@{{IP}}

