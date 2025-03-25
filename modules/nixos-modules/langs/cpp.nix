{ pkgs, ... }:

{
  users.users.takaobsid.packages = with pkgs; [
    libmysqlclient
    libmysqlconnectorcpp
    # llvmPackages.libcxxClang
    llvmPackages.libcxxStdenv
    llvmPackages.lld
    clang-tools
    # clang-unwrapped
    # libgccjit
    # libgcc
    gcc-unwrapped
    gnumake
    cmake
    lldb_20
    # ld64
  ];
}
