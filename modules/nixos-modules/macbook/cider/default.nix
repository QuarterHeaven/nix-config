{
appimageTools,
lib,
...
}:

appimageTools.wrapType2 rec {
  # inherit name src;
  pname = "cider";
  version = "2.4.0";
  name = "${pname}-${version}";

  src = /home/takaobsid/bin/Cider-linux-appimage-x64.AppImage;

  extraInstallCommands = let
    contents = appimageTools.extract { inherit name src; };
    in ''
    # mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${contents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "A new look into listening and enjoying Apple Music in style and performance.";
    homepage = "https://cider.sh";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" /* ... */ ];
  };
}
