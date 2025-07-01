{ pkgs, lib, ... }:

let
  gcc       = pkgs.gcc;
  libgcc    = pkgs.libgcc;
  libcxx    = pkgs.llvmPackages_latest.libcxx;
  libcxxrt  = pkgs.libcxxrt;
in {
  users.users.takaobsid.packages = with pkgs; [
    libmysqlclient
    libmysqlconnectorcpp
    # llvmPackages.libcxxClang
    # llvmPackages.libcxxStdenv
    # llvmPackages.lld
    # clang-tools
    # libgccjit
    llvmPackages_latest.lldb
    llvmPackages_latest.libllvm
    libcxx
    libcxxrt
    llvmPackages_latest.clang
    # libgcc
    # gcc-unwrapped
    # gcc
    gnumake
    cmake
    lldb_20
    # ld64
  ];

  environment.variables = {
    LIBRARY_PATH = lib.concatStringsSep ":" [
      "${gcc.out}/lib/gcc/${gcc.version}"
      "${libcxx.out}/lib"
      "${libcxxrt.out}/lib"
    ];
  };
}
