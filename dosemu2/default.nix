{ stdenv, pkgs, lib, fetchFromGitHub, autoreconfHook, pkgconfig, flex, bison
, libbsd, fdpp, hexdump, SDL2, slang }:
# TODO: make plugins configurable

stdenv.mkDerivation rec {
  pname = "dosemu2";
  version = "da80182e2f4475f3ee3f997c9f1f2946f8d7d5ab";

  meta = with lib; {
    description = "DOS Emulator for Linux";
    longDescription = ''
      A virtual machine that allows you to run DOS programs under Linux.
    '';
    homepage = "htips://github.com/dosemu2/dosemu2";
    license = licenses.gpl2Plus;
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
    repo = "dosemu2";
    rev = version;
    sha256 = "1l8lrwsmgm0r9gr91j7pr3lrc17f4x9hrsikb0awcdah7jjidqg0";
  };

  postPatch = ''
    substituteInPlace getversion --replace '$DATE' '1995-08-24'
  '';

  autoreconfFlags = "-I m4";

  # TODO: patch looking up comcom32 in the nix store
  postConfigure = ''
    substituteInPlace src/base/core/int.c --replace 'CONFIG_TIME' '"1995-08-24"'
  '';

  nativeBuildInputs =
    [ pkgconfig autoreconfHook flex bison libbsd fdpp hexdump SDL2 slang ];
}
