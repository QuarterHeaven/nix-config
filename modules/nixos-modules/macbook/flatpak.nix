{ lib, ... }:

{
  services.flatpak = {
    enable = true;
    remotes = lib.mkOptionDefault [{
      name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }];

    packages = [
      "com.tencent.WeChat"
      "com.wps.Office"
      "com.qq.QQ"
      "page.codeberg.JakobDev.jdMinecraftLauncher"
      "com.belmoussaoui.Authenticator"
      "sh.ppy.osu"
    ];

    uninstallUnmanaged = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    overrides = {
      global = {
	Environment = {
	  XMODIFIERS = "@im=fcitx";
	  GTK_IM_MODULE="fcitx";
	  QT_IM_MODULE="fcitx";
	  SDL_IM_MODULE="fcitx";
	  GLFW_IM_MODULE="fcitx";
	};
      };
    };
  };
}
