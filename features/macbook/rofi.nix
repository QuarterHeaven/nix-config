{ ... }:

{
  programs.rofi = {
    enable = true;
    font = "Bookerly 14";
    terminal = "/etc/profiles/per-user/takaobsid/bin/wezterm";
    cycle = true;
    extraConfig = {
      show-icons = true;
      modes = "window,drun,run,ssh,combi";
    };
  };
}
