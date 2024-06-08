{ inputs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [ "${inputs.dotfiles}/alacritty/catppuccin-macchiato.toml" ];

      window = { opacity = 0.9; };
    };
  };
}
