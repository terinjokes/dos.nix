{ stdenv, lib, pkgs, fetchFromGitHub, gcc, binutils }:

stdenv.mkDerivation rec {
  pname = "comcom32";
  version = "5c8d8d8d147eb71e8875d5b5f6053cc3d372716a";

  meta = with lib; {
    description = "32-bit command interpreter for dosemu2 and fdpp";
    homepage = "https://github.com/dosemu2/comcom32";
    licenses = gpl3Only;
    maintainers = [{
      email = "terinjokes@gmail.com";
      github = "terinjokes";
      githubId = 273509;
      name = "Terin Stock";
    }];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

  src = fetchFromGitHub {
    owner = "dosemu2";
    repo = "comcom32";
    rev = version;
    sha256 = "08v7ysnmb0slc46f09xampaq5g4760q9zjhkzh0pbqfrl4qwgkla";
  };

  enableParallelBuilding = true;

  DOS_CC = "${gcc}/bin/i686-pc-msdosdjgpp-gcc";
  DOS_LD = "${gcc}/bin/i686-pc-msdosdjgpp-gcc";
  DOS_STRIP = "${binutils}/bin/i686-pc-msdosdjgpp-strip";

  makeFlags = [ "PREFIX=$(out)" ];
}
