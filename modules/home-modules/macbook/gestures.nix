{ pkgs, inputs, ... }:

{
  services.fusuma = {
    enable = true;
    extraPackages = with pkgs; [ ydotool coreutils xorg.xprop ];
    settings = {
      swipe = {
        "3" = {
          begin = {
            command = "ydotool click 40";
          };
          update = {
            command = "ydotool mousemove -- $move_x, $move_y";
            interval = 1.0e-2;
            # accel = 1.7;
          };
          end = { command = "ydotool click 80"; };
        };
	"4" = {
	  "left" = {
	    # LMeta + L
	    command = "ydotool key 125:1 38:1 38:0 125:0";
	  };
	  "right" = {
	    # LMeta + H
	    command = "ydotool key 125:1 35:1 35:0 125:0";
	  };
	  "down" = {
	    # LMeta + K
	    command = "ydotool key 125:1 37:1 37:0 125:0";
	  };
	  "up" = {
	    # LMeta + J
	    command = "ydotool key 125:1 36:1 36:0 125:0";
	  };
	};
      };

      # pinch = {
      # 	"in" = {
      # 	  "3" = {
      # 	    # LAlt + Tab
      # 	    command = "ydotool key 56:1 15:1 15:0 56:0";
      # 	  };
      # 	  "4" = {
      # 	    # LAlt + Space
      # 	    command = "ydotool key 56:1 57:1 57:0 56:0";
      # 	  };
      # 	};

      # 	"out" = {
      # 	  "4" = {
      # 	    # LAlt + Tab
      # 	    command = "ydotool key 56:1 15:1 15:0 56:0";
      # 	  };
      # 	};
      # };
      pinch = {
	"3" = {
	  "in".command = "ydotool key 56:1 15:1 15:0 56:0"; # LAlt + Tab
	  "out".command = "ydotool key 1:1 1:0"; # ESC
	};

	"4" = {
	  "in".command = "ydotool key 56:1 57:1 57:0 56:0"; # LAlt + Space
	  "out".command = "ydotool key 1:1 1:0"; # ESC
	};
      };
      threshold =
	{  pinch = 0.5;};

      interval =
	{  swipe = 0.75;
	pinch = 1.0;};


    };
  };
}
