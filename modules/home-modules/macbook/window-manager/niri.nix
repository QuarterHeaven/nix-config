{ config, inputs, pkgs, lib, ... }:
 with lib; let
   binds = {
   suffixes,
   prefixes,
   substitutions ? {},
   }: let
     replacer = replaceStrings (attrNames substitutions) (attrValues substitutions);
     format = prefix: suffix: let
       actual-suffix =
         if isList suffix.action
              then {
                action = head suffix.action;
                args = tail suffix.action;
              }
              else {
                inherit (suffix) action;
                args = [];
              };

       action = replacer "${prefix.action}-${actual-suffix.action}";
       in {
         name = "${prefix.key}+${suffix.key}";
         value.action.${action} = actual-suffix.args;
       };
     pairs = attrs: fn:
            concatMap (key:
              fn {
                inherit key;
                action = attrs.${key};
              }) (attrNames attrs);
     in
     listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [(format prefix suffix)])));
   in
   {
     programs.niri = {
       settings = {
	 input = {
           focus-follows-mouse = false;
           # keyboard.xkb = {
           #   layout = "us";
           #   options = "ctrl:swapcaps";
           # };
           touchpad = {
             natural-scroll = true;
             dwt = true;
             click-method = "clickfinger";
             tap = true;
           };
	 };

	 outputs = {
           "eDP-1" = {
             # scale = 1.6;
             position = {
               # x = 2048;
               # y = 576;
	       x = 2560;
	       y = 720;
             };
           };
           "DP-4" = {
             # scale = 1.25;
             position = {
               x = 0;
               y = 0;
             };
           };
	 };

	 layout = {
           center-focused-column = "never";
           default-column-width = { proportion = 1. / 2.; };
           preset-column-widths = [
             { proportion = 1. / 3.; }
             { proportion = 1. / 2.; }
             { proportion = 2. / 3.; }
           ];

           gaps = 10;
	 };

	 prefer-no-csd = true;

	 window-rules = [
           {
             draw-border-with-background = false;
             geometry-corner-radius =
               let
		 r = 9.0;
		 in
		 {
		   top-left = r;
		   top-right = r;
		   bottom-left = r;
		   bottom-right = r;
		 };
             clip-to-geometry = true;
           }
           {
             matches = [{ is-focused = false; }];
             opacity = 0.6;
           }
           {
             matches = [{ is-focused = true; }];
             opacity = 0.95;
           }
	 ];

	 spawn-at-startup = [
           { command = [ "waybar" ]; }
           { command = [ "wezterm" ]; }
	   #  { command = [ "keepassxc" ]; }
           { command = [ "fcitx5 -r -d" ]; }
           { command = [ "ags" ]; }
           { command = [ ''ydotoold --socket-path="/run/user/$(id -u)/.ydotool_socket" --socket-own="$(id -u):$(id -g)'' ]; }
	 ];

	 binds = with config.lib.niri.actions;  lib.attrsets.mergeAttrsList [
	{
	  "Alt+Q".action = close-window;
	  "Alt+Ctrl+T" = {
	    action = spawn [ "foot" "-e" "fish" ];
	    cooldown-ms = 500;
	  };
	  "Alt+Space".action = spawn [ "rofi" "-show" "combi" ];
	  "Alt+E" = {
	    action = spawn [ "emacs" ];
	    cooldown-ms = 500;
	  };


	  "Super+WheelScrollDown".action = focus-workspace-down;
	  "Super+WheelScrollDown".cooldown-ms = 500;
	  "Super+WheelScrollUp".action = focus-workspace-up;
	  "Super+WheelScrollUp".cooldown-ms = 500;
	  "Super+WheelScrollRight".action = focus-column-right;
	  "Super+WheelScrollLeft".action = focus-column-left;

	  "Super+H".action = focus-column-left;
	  "Super+L".action = focus-column-right;
	  "Super+J".action = focus-workspace-down;
	  "Super+K".action = focus-workspace-up;
	  "Super+Left".action = focus-column-left;
	  "Super+Right".action = focus-column-right;
	  "Super+Down".action = focus-window-down;
	  "Super+Up".action = focus-window-up;

	  "Super+Shift+Left".action = move-column-left;
	  "Super+Shift+Down".action = move-workspace-down;
	  "Super+Shift+Up".action = move-workspace-up;
	  "Super+Shift+Right".action = move-column-right;
	  "Super+Shift+H".action = move-column-left;
	  "Super+Shift+J".action = move-window-down-or-to-workspace-down;
	  "Super+Shift+K".action = move-window-up-or-to-workspace-up;
	  "Super+Shift+L".action = move-column-right;

	  # "Super+U".action = move-workspace-down;
	  # "Super+I".action = move-workspace-up;
	  "Super+I".action = consume-or-expel-window-left;
	  "Super+O".action = consume-or-expel-window-right;
	  "Super+Shift+I".action = move-workspace-down;
	  "Super+Shift+O".action = move-workspace-up;

	  "Super+Minus".action = set-column-width "-10%";
	  "Super+Equal".action = set-column-width "+10%";
	  "Super+Shift+Minus".action = set-window-height "-10%";
	  "Super+Shift+Equal".action = set-window-height "+10%";

	  "Alt+Shift+Left".action = focus-monitor-left;
	  "Alt+Shift+Down".action = focus-monitor-down;
	  "Alt+Shift+Up".action = focus-monitor-up;
	  "Alt+Shift+Right".action = focus-monitor-right;
	  "Alt+Shift+H".action = focus-monitor-left;
	  "Alt+Shift+J".action = focus-monitor-down;
	  "Alt+Shift+K".action = focus-monitor-up;
	  "Alt+Shift+L".action = focus-monitor-right;

	  "Alt+Shift+Ctrl+Left".action = move-column-to-monitor-left;
	  "Alt+Shift+Ctrl+Down".action = move-column-to-monitor-down;
	  "Alt+Shift+Ctrl+Up".action = move-column-to-monitor-up;
	  "Alt+Shift+Ctrl+Right".action = move-column-to-monitor-right;
	  "Alt+Shift+Ctrl+H".action = move-column-to-monitor-left;
	  "Alt+Shift+Ctrl+J".action = move-column-to-monitor-down;
	  "Alt+Shift+Ctrl+K".action = move-column-to-monitor-up;
	  "Alt+Shift+Ctrl+L".action = move-column-to-monitor-right;

	  "Super+R".action = switch-preset-column-width;
	  "Super+F".action = maximize-column;
	  "Super+Shift+F".action = fullscreen-window;
	  "Super+C".action = center-column;

	  "Super+G".action = screenshot;
	}
	   (binds {
                suffixes = builtins.listToAttrs (map (n: {
                  name = toString n;
                  value = ["workspace" n];
                }) (range 1 9));
                prefixes."Alt" = "focus";
                prefixes."Alt+Shift" = "move-window-to";
              })
	 ];
       };
     };
   }
