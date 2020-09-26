with import (builtins.fetchTarball {
  name = "nixos-unstable";
  url = "https://github.com/NixOS/nixpkgs/archive/${
      builtins.getEnv "NIX_CHANNEL"
    }.tar.gz";
}) { overlays = [ (import ./..) ]; };

pkgs.dosemu2
