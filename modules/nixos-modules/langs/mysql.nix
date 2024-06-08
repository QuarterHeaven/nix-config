{ config, pkgs, inputs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    settings = {
      mysqld = {
        datadir = "/var/lib/mysql/";
        port = 3306;
        lower_case_table_names = 1;
      };
    };
  };

  users.users.takaobsid.packages = with pkgs; [
    antares
  ];
}
