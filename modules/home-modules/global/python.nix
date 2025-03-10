{ pkgs, ... }:

{
  home.packages = with pkgs;
    [
      (python311.withPackages (ps:
        with ps; [
          pip
          virtualenv
          epc
          sexpdata
          six
          pyqt6
          pyqt6-sip
          inflect
          # pynput
          grip
        ]))
      # cudaPackages.cudatoolkit
      poetry
      black # formatter
    ];
}
