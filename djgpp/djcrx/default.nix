{ stdenv, lib, pkgs, fetchzip, binutils, gcc, breakpointHook, bison, texinfo }:

stdenv.mkDerivation {
  pname = "djgpp-djcrx";
  version = "2.05";

  meta = with lib; {
    description = "Headers and utilities for the djgpp cross-compiler";
    homepage = "http://www.delorie.com/djgpp/";
    licenses = [ licenses.gpl2 licenses.lgpl21 ];
    maintainers = [{
      email = "terinjokes@gmail.com";
      github = "terinjokes";
      githubId = 273509;
      name = "Terin Stock";
    }];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

  srcs = [
    (fetchzip {
      url = "http://www.delorie.com/pub/djgpp/current/v2/djcrx205.zip";
      sha256 = "0plzg5djlh61isax5zwd5kzjmvmsxandjq8l7943acaz72m501wq";
      stripRoot = false;
    })
    (fetchzip {
      url = "http://www.delorie.com/pub/djgpp/current/v2/djlsr205.zip";
      sha256 = "00szz6vf10gg3p34fnwcp49c2z52r8vhpi02zq6dk2r13kmsdayg";
      stripRoot = false;
    })
  ];

  unpackPhase = ''
    runHook preUnpack

    mkdir source
    for _src in $srcs; do
      cp -R --no-preserve=mode,ownership "$_src"/* source
    done

    runHook postUnpack
    cd source
  '';

  target = "i686-pc-msdosdjgpp";

  patches = [
    ./djgpp-djcrx-gcccompat.patch
    ./ttyscrn.patch
    ./nmemalign.patch
    ./fseeko64.patch
    ./asm.patch
    ./dxegen.patch
  ];

  postPatch = ''
    substituteInPlace src/makefile.def --replace "i586-pc-msdosdjgpp" "$target"
    substituteInPlace src/dxe/makefile.dxe --replace "i586-pc-msdosdjgpp" "$target"
    substituteInPlace src/dxe/makefile.dxe --replace "ln" "ln -f"

    ln -fs float.h include/djfloat.h
    sed -i 's/<float\.h>/<djfloat.h>/' src/libc/{go32/dpmiexcp,emu387/npxsetup}.c src/utils/redir.c
  '';

  nativeBuildInputs = [ binutils gcc breakpointHook bison texinfo ];

  buildPhase = ''
    cd src
    make clean
    make -j1

    cd dxe
    make -f makefile.dxe
  '';

  installPhase = ''
    cd ../..
    install -dm 0755 "$out/bin"
    install -dm 0755 "$out/$target/bin"
    install -dm 0755 "$out/$target/sys-include"

    cp -r include/* $out/$target/sys-include/
    cp -r lib $out/$target/

    cd hostbin
    for _file in djasm mkdoc stubedit stubify; do
      install -m 0755 $_file.exe "$out/$target/bin/$_file"
      ln -s ../$target/bin/$_file "$out/bin/$target-$_file"
    done

    cd ../src/dxe
    for _file in dxe3gen dxe3res; do
      install -m 0755 $_file "$out/$target/bin/$_file"
      ln -s ../$target/bin/$_file "$out/bin/$target-$_file"
    done
    ln -s dxe3gen "$out/$target/bin/dxegen"

    cd ../../info
    for _file in *.info; do
      install -Dm0644 $_file "$out/share/info/djgpp-$_file"
    done
  '';
}
