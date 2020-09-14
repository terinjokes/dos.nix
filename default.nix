self: prev:

rec {
  dosemu2 = self.callPackage ./dosemu2 { };
  fdpp = self.callPackage ./fdpp { };
  djgpp = {
    binutils = self.callPackage ./djgpp/binutils { };
    djcrx-bootstrap = self.callPackage ./djgpp/djcrx/bootstrap.nix { };
    djcrx = self.callPackage ./djgpp/djcrx {
      binutils = djgpp.binutils;
      gcc = djgpp.gcc-bootstrap;
    };
    gcc-bootstrap = self.callPackage ./djgpp/gcc {
      binutils = djgpp.binutils;
      djcrx = djgpp.djcrx-bootstrap;
    };
    gcc = self.callPackage ./djgpp/gcc {
      binutils = djgpp.binutils;
      djcrx = djgpp.gjcrx;
    };
  };
  comcom32 = self.callPackage ./comcom32 {
    binutils = djgpp.binutils;
    gcc = djgpp.gcc;
  };
}
