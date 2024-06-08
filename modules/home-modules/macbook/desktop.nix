{ ... }:

{
  xdg.desktopEntries.navicat = {
    name = "Navicat Premium 16";
    genericName = "Database Development Tool";
    exec = "/home/takaobsid/Dropbox/bin/navicat16-premium-cs.appimage";
    icon ="/home/takaobsid/Dropbox/bin/navicat.jpg";
    terminal = false;
    type = "Application";
    categories = [ "Development" ];
  };

  # xdg.desktopEntries.cider = {
  #   name = "Cider";
  #   genericName = "Apple Music Client for Linux";
  #   exec = "/home/takaobsid/Dropbox/bin/Cider-linux-appimage-x64.AppImage";
  #   terminal = false;
  #   type = "Application";
  #   categories = [ "Music" ];
  # };

  xdg.desktopEntries.apifox = {
    name = "Apifox";
    genericName = "Apifox = Postman + Swagger + Mock + JMeter";
    exec = "/home/takaobsid/Dropbox/bin/Apifox.AppImage";
    terminal = false;
    type = "Application";
    categories = [ "Development" ];
  };

    xdg.desktopEntries.Antares = {
    name = "AntaresSQL";
    genericName = "Database Development Tool";
    exec = "/etc/profiles/per-user/takaobsid/bin/antares --ozone-platform-hint=auto";
    icon ="/home/takaobsid/Dropbox/bin/it.fabiodistasio.AntaresSQL.png";
    terminal = false;
    type = "Application";
    categories = [ "Development" ];
  };

}
