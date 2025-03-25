{ pkgs, ... }:

{
  users.users.takaobsid.packages = with pkgs; [
    libmysqlclient
    libmysqlconnectorcpp
    # llvmPackages.libcxxClang
    # llvmPackages.libcxxStdenv
    # llvmPackages.lld
    clang-tools
    # libgccjit
    # libgcc
    # gcc-unwrapped
    gcc
    gnumake
    cmake
    lldb_20
    # ld64
  ];
}
