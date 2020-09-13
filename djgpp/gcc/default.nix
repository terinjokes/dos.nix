{ stdenv, lib, pkgs, fetchurl, zlib, libmpc, gmp, mpfr, isl, binutils, djcrx }:

stdenv.mkDerivation rec {
  pname = "djgpp-gcc";
  version = "10.2.0";

  meta = with lib; {
    description = "GNU Compiler Collection, version 10.2.0 (DJGPP version)";
    homepage = "https://gcc.gnu.org/";
    licenses = [ gpl3Only licenses.lgpl3Only ];
    maintainers = [{
      email = "terinjokes@gmail.com";
      github = "terinjokes";
      githubId = 273509;
      name = "Terin Stock";
    }];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "130xdkhmz1bc2kzx061s3sfwk36xah1fw5w332c0nzwwpdl47pdq";
  };

  dontStrip = true;

  nativeBuildInputs = [ zlib libmpc gmp mpfr isl binutils djcrx ];

  hardeningDisable = [ "format" ];

  patches = [ ./lto.patch ./gcc-djgpp.diff ];

  postPatch = ''
    substituteInPlace gcc/config/i386/djgpp.h --replace 'stubify' '${djcrx}/bin/i686-pc-msdosdjgpp-stubify'
  '';

  enableParallelBuilding = true;

  preConfigure = ''
    rm -Rf zlib
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
  '';

  configurePlatforms = [ "build" "host" ];

  configureFlags = [
    "--with-as=${binutils}/bin/i686-pc-msdosdjgpp-as"
    "--with-ld=${binutils}/bin/i686-pc-msdosdjgpp-ld"
    "--target=i686-pc-msdosdjgpp"
    "--enable-languages=c,c++"
    "--enable-shared"
    "--enable-static"
    "--enable-threads=no"
    "--with-system-zlib"
    "--with-isl"
    "--enable-lto"
    "--disable-libgomp"
    "--disable-multilib"
    "--enable-checking=release"
    "--disable-libstdcxx-pch"
    "--enable-libstdcxx-filesystem-ts"
    "--disable-install-libiberty"
    "--with-headers=${djcrx}/i686-pc-msdosdjgpp/sys-include"
    "--with-libs=${djcrx}/i686-pc-msdosdjgpp/lib"
  ];

  postConfigure = ''
    sed -e '/TOPLEVEL_CONFIGURE_ARGUMENTS=/d' -i Makefile
  '';

  postInstall = ''
    rm -rf $out/libexec/gcc/*/*/install-tools
    rm -rf $out/lib/gcc/*/*/install-tools

    for i in $out/bin/*-gcc*; do
        if cmp -s $out/bin/gcc $i; then
            ln -sfn gcc $i
        fi
    done

    for i in $out/bin/c++ $out/bin/*-c++* $out/bin/*-g++*; do
        if cmp -s $out/bin/g++ $i; then
            ln -sfn g++ $i
        fi
    done

    ln -sf gcc.1 "$out"/share/man/man1/g++.1
  '';

  makeFlags = [ "all-gcc" "all-target-libgcc" ];
  installTargets = "install-gcc install-target-libgcc";
}
