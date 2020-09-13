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
    environment.systemPackages = with pkgs; [ dosemu2 ];
    
    # ...
  }
```

## Packages

This overlay provides the following packages:

| Package            | Description                          |
| -------            | -----------                          |
| [dosemu2][dosemu2] | DOS Emulator for Linux               |
| [djgpp][djgpp]     | Cross-compiler targetting 32-bit DOS |
| [fdpp][fdpp]       | A 64-bit DOS core                    |


[overlays]: https://nixos.wiki/wiki/Overlays
[dosemu2]: https://github.com/dosemu2/dosemu2
[djgpp]: http://www.delorie.com/djgpp/
[fdpp]: https://github.com/dosemu2/fdpp
