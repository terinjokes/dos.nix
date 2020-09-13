{ stdenv, lib, pkgs, fetchzip }:

stdenv.mkDerivation {
  pname = "djgpp-djcrx-bootstrap";
  version = "2.05";

  meta = with lib; {
    description =
      "Headers and utilities for the djgpp cross-compiler (bootstrap)";
    homepage = "http://www.delorie.com/djgpp/";
    licenses = [ licenses.gpl2Only licenses.lgpl21Only ];
    maintainers = [{
      email = "terinjokes@gmail.com";
      github = "terinjokes";
      githubId = 273509;
      name = "Terin Stock";
    }];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

  src = fetchzip {
    url = "ftp://ftp.delorie.com/pub/djgpp/current/v2/djcrx205.zip";
    sha256 = "0plzg5djlh61isax5zwd5kzjmvmsxandjq8l7943acaz72m501wq";
    stripRoot = false;
  };

  enableParallelBuilding = true;

  target = "i686-pc-msdosdjgpp";

  buildPhase = ''
    make -f cross/makefile stub CFLAGS=""
  '';

  installPhase = ''
    install -dm 0755 "$out/bin"
    install -dm 0755 "$out/$target/bin"
    install -dm 0755 "$out/$target/sys-include"
    cp -r include/* "$out/$target/sys-include"
    cp -r lib "$out/$target/"

    install -Dm 0755 stubedit "$out/$target/bin/stubedit"
    ln -s $out/$target/bin/stubedit $out/bin/$target-stubedit
    install -Dm 0755 stubify "$out/$target/bin/stubify"
    ln -s $out/$target/bin/stubify $out/bin/$target-stubify
  '';
}
