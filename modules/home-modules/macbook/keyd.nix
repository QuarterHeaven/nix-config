{ ... }:

{
  options.services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "layer(control)";
            leftcontrol = "capslock";
          };
        };
      };
      macbookKeyboard = {
        ids = [ "05ac:027e" ];
        settings = {
          main = {
            leftalt = "layer(meta)";
            leftmeta = "layer(alt)";
            capslock = "layer(control)";
            leftcontrol = "capslock";
          };
        };
      };
    };
  };
}
