{ stdenv, pkgs, lib, fetchurl, bison, flex, m4, texinfo, zlib, gettext }:

stdenv.mkDerivation rec {
  pname = "djgpp-binutils";
  version = "2.34";

  meta = with lib; {
    description = "Tools for manipulating binaries (djgpp version)";
    longDescription = ''
      The GNU Binutils are a collection of binary tools. The main ones are `ld` (the GNU linker) and `as` (the GNU assembler).
      They aso include the BFD (Binary File Descriptor) library, `nm`, `strip`, etc. (djgpp version)
    '';
    homepage = "https://www.gnu.org/software/binutils/";
    license = licenses.gpl3Plus;
    maintainers = [{
      email = "terinjokes@gmail.com";
      github = "terinjokes";
      githubId = 273509;
      name = "Terin Stock";
    }];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

  src = fetchurl {
    url = "mirror://gnu/binutils/binutils-${version}.tar.bz2";
    sha256 = "1rin1f5c7wm4n3piky6xilcrpf2s0n3dd5vqq8irrxkcic3i1w49";
  };

  patches = [
    ./binutils-djgpp.patch
    ./binutils-bfd-djgpp.patch
    ./lto-discard.patch
    ./deterministic.patch
  ];

  preConfigure = ''
    # Use symlinks instead of hard links to save space ("strip" in the
    # fixup phase strips each hard link separately).
    for i in binutils/Makefile.in gas/Makefile.in ld/Makefile.in gold/Makefile.in; do
        sed -i "$i" -e 's|ln |ln -s |'
    done
  '';

  NIX_CFLAGS_COMPILE = "-static-libgcc";

  enableParallelBuilding = true;

  nativeBuildInputs = [ flex bison m4 texinfo zlib gettext ];

  configureFlags = [
    "--disable-shared"
    "--enable-static"
    "--with-system-zlib"
    "--enable-deterministic-archives"
    "--enable-new-dtags"
    "--target=i686-pc-msdosdjgpp"
    "--enable-lto"
    "--disable-nls"
    "--disable-install-libiberty"
    "--disable-multilib"
    "--disable-nls"
    "--disable-werror"
  ];
}
