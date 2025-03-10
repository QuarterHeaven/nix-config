{ pkgs, lib, stdenv, tdlib_src, ... }:

stdenv.mkDerivation {
  pname = "myTdlib";
  version = "1.0.0";

  src = tdlib_src;

  buildInputs = with pkgs; [
    git
    makeWrapper
    openssl
    zlib
  ];

  nativeBuildInputs = with pkgs; [
    cmake
    makeWrapper
    gperf
    php
  ];

  configurePhase = ''
    mkdir -p build
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out ..
  '';

  buildPhase = ''
    make -j$(nproc)
  '';

  installPhase = ''
    make install PREFIX=$out
  '';
  

  meta = with pkgs.lib; {
    description = "TDLib is the library for building Telegram clients, built from source";
    license = licenses.bsd3;
    maintainers = [ maintainers.TakaObsid ];
  };
}

