{ pkgs, ... }:

{
  home.packages = with pkgs; [
    python311Packages.pip
    python311Packages.virtualenv
    python311Packages.epc
    python311Packages.sexpdata
    python311Packages.six
    python311Packages.pyqt6
    python311Packages.pyqt6-sip
    python311Packages.inflect
    python311Packages.grip

    poetry
    black
    
    # cudaPackages.cudatoolkit
  ];
}
