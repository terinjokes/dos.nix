{ clangStdenv, pkgs, lib, fetchFromGitHub, bison, flex, autoconf, nasm, gnused
, gnugrep }:

clangStdenv.mkDerivation rec {
  pname = "fdpp";
  version = "1.0";

  meta = with lib; {
    description = "A 64-bit DOS core";
    longDescription = ''
      fdpp ("FreeDOS plus-plus") is a user-space library that can run DOS programs.
    '';
    homepage = "https://github.com/dosemu2/fdpp";
    licenses = [ licenses.gpl3 ];
    maintainers = [{
      email = "terinjokes@gmail.com";
      github = "terinjokes";
      githubId = 273509;
      name = "Terin Stock";
    }];
    platforms = platforms.all;
  };

  src = fetchFromGitHub {
    owner = "dosemu2";
    repo = "fdpp";
    rev = version;
    sha256 = "1ldrzklf244h21w0g2vpc6d5nlkxlfhcl2z6g3897mamv4cn4mfk";
  };

  patches = [ ./0001-fix-parse_decls.patch ./0002-makefile-git.patch ];

  postPatch = ''
    patchShebangs ./fdpp/parsers
    substituteInPlace fdpp/parsers/makefile --replace 'lex $^' 'flex $^'
    substituteInPlace hdr/version.h --replace '__DATE__' '"Aug 24 1995"'
  '';

  NIX_CFLAGS_COMPILE = "-DKERNEL_VERSION=${version}";

  nativeBuildInputs = [ flex bison autoconf nasm gnused gnugrep ];

  makeFlags = [ "PREFIX=$(out)" ];
}
