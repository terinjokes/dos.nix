self: prev:

rec {
  dosemu2 = self.callPackage ./dosemu2 { };
  fdpp = self.callPackage ./fdpp { };
}
