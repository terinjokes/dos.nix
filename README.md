# dos.nix

An overlay of DOS tools for nix.

## Usage

### Overlay Imports

You can import these packages using the Nixpkgs overlay feature, by consulting
the [wiki page on Overlays][overlays]. An example is provided below, which you
may want to modify.


``` nix
{ config, lib, pkgs, ...}:
let
  dosOverlay = (import (builtins.fetchTarball "https://github.com/terinjokes/dos.nix/archive/master.tar.gz"));
in
  {
    nixpkgs.overlays = [ dosOverlay ];
    environment.systemPackages = with pkgs; [ fdpp ];
    
    # ...
  }
```

## Packages

This overlay provides the following packages:

| Package      | Description       |
| -------      | -----------       |
| [fdpp][fdpp] | A 64-bit DOS core |


[overlays]: https://nixos.wiki/wiki/Overlays
[fdpp]: https://github.com/dosemu2/fdpp
