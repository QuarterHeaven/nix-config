{ features, ... }:

{
#   # Enable the X11 windowing system.
#   services.xserver.enable = true;

#   # Enable the KDE Plasma Desktop Environment.
#   services.xserver.displayManager.sddm.enable = true;
#   services.xserver.desktopManager.plasma5.enable = true;

#     # Configure keymap in X11
#   services.xserver = {
#     layout = "us";
#     xkbVariant = "";
#   };

#     # Enable automatic login for the user.
#   services.xserver.displayManager.autoLogin.enable = true;
#   services.xserver.displayManager.autoLogin.user = "taka";
}
