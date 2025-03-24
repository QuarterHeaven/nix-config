{ pkgs, ... }:

{
  users.users.takaobsid.packages = with pkgs; [
    libmysqlclient
    libmysqlconnectorcpp
    llvmPackages.libcxxClang
    llvmPackages.libcxxStdenv
    clang-tools
    libgccjit
    # libgcc
    # gcc-unwrapped
    gnumake
    cmake
    lldb_20
  ];
}
