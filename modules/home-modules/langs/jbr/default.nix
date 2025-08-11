{pkgs, ...}: let
  jbr-commit = "2c287a5f3642c970165096bf38bbc34cde63548f";
  jbr-branch = "jbr21";
  jbr-hash = "sha256-SxWd8dJtQnQBADdH2kQX0AGXZJpkeh9Pm4NKuRSLIP8=";
  bootstrap = pkgs.jdk21;
in
  pkgs.stdenv.mkDerivation {
    pname = "jbr";
    version = "${jbr-branch}-${jbr-commit}";

    src = pkgs.fetchFromGitHub {
      owner = "JetBrains";
      repo = "JetBrainsRuntime";
      rev = jbr-commit;
      hash = jbr-hash;
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
      autoconf
      unzip
      ensureNewerSourcesForZipFilesHook
    ];

    buildInputs = with pkgs;
      [
        cpio
        file
        which
        zip
        perl
        zlib
        cups
        freetype
        alsa-lib
        libjpeg
        giflib
        libpng
        zlib
        lcms2
        fontconfig
        wayland
        gtk3
      ]
#      ++ (with pkgs.gnome2; [
#        gnome_vfs
#        GConf
#        glib
#      ])
      ++ (with pkgs.xorg; [
        libX11
        libICE
        libXrender
        libXext
        libXtst
        libXt
        libXtst
        libXi
        libXinerama
        libXcursor
        libXrandr
      ]);

    disallowedReferences = [bootstrap];

    patches = [
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/nixos-unstable/pkgs/development/compilers/openjdk/fix-java-home-jdk21.patch";
        sha256 = "sha256-+2kePaeAYa/jGwnKRbJfCn8FE0I3O2aVhLXhXu679Y0=";
      })
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/nixos-unstable/pkgs/development/compilers/openjdk/read-truststore-from-env-jdk10.patch";
        sha256 = "sha256-kZedLbhA8gmxl4+da3GH9JmGUmYFvqqphhf9FOpdNdc=";
      })
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/nixos-unstable/pkgs/development/compilers/openjdk/currency-date-range-jdk10.patch";
        sha256 = "sha256-VHB+bH3R2hg1W3MSRhedXMVtCOHjfsalv+g4UkfR+VE=";
      })
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/nixos-unstable/pkgs/development/compilers/openjdk/increase-javadoc-heap-jdk13.patch";
        sha256 = "sha256-WZXxwmXMtfbwHbAqGFqBTWLcp4AUK5oE5t7Ld23VMZw=";
      })
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/nixos-unstable/pkgs/development/compilers/openjdk/ignore-LegalNoticeFilePlugin-jdk18.patch";
        sha256 = "sha256-d0rfPleQyYdk66mEJCZXLRscnXBmh/DcDy7kdH5BQ3w=";
      })

      # -Wformat etc. are stricter in newer gccs, per
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79677
      # so grab the work-around from
      # https://src.fedoraproject.org/rpms/java-openjdk/pull-request/24
      (pkgs.fetchurl {
        url = "https://src.fedoraproject.org/rpms/java-openjdk/raw/06c001c7d87f2e9fe4fedeef2d993bcd5d7afa2a/f/rh1673833-remove_removal_of_wformat_during_test_compilation.patch";
        sha256 = "082lmc30x64x583vqq00c8y0wqih3y4r0mp1c4bqq36l22qv6b6r";
      })

      # Fix build for gnumake-4.4.1:
      #   https://github.com/openjdk/jdk/pull/12992
      (pkgs.fetchpatch {
        name = "gnumake-4.4.1";
        url = "https://github.com/openjdk/jdk/commit/9341d135b855cc208d48e47d30cd90aafa354c36.patch";
        hash = "sha256-Qcm3ZmGCOYLZcskNjj7DYR85R4v07vYvvavrVOYL8vg=";
      })

      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/nixos-unstable/pkgs/development/compilers/openjdk/swing-use-gtk-jdk13.patch";
        sha256 = "sha256-80v2Luf4KCjQ1G7cMbWOds8JpvoOmWYA72VlSadPUoQ=";
      })
    ];

    postPatch = ''
      chmod +x configure
      patchShebangs --build configure
    '';

    configureFlags = [
      "--with-boot-jdk=${bootstrap}"
      "--with-version-opt=nixos-jb"
      "--with-version-pre="
      "--enable-unlimited-crypto"
      "--with-native-debug-symbols=internal"
      "--with-libjpeg=system"
      "--with-giflib=system"
      "--with-libpng=system"
      "--with-zlib=system"
      "--with-lcms=system"
      "--with-stdc++lib=dynamic"
      "--with-jvm-features=zgc"
    ];

    enableParallelBuilding = false;
    separateDebugInfo = true;

    env.NIX_CFLAGS_COMPILE = "-Wno-error -march=x86-64-v3 -mtune=znver3";

    NIX_LDFLAGS = toString [
      "-lfontconfig"
      "-lcups"
      "-lXinerama"
      "-lXrandr"
      "-lmagic"
      "-lgtk-3"
      "-lgio-2.0"
      "-lgnomevfs-2"
      "-lgconf-2"
    ];

    buildFlags = ["images"];

    installPhase = ''
      mkdir -p $out/lib

      ls build/*/images
      mv build/*/images/jdk $out/lib/openjdk

      # Remove some broken manpages.
      rm -rf $out/lib/openjdk/man/ja*

      # Mirror some stuff in top-level.
      mkdir -p $out/share
      ln -s $out/lib/openjdk/include $out/include
      ln -s $out/lib/openjdk/man $out/share/man

      # IDEs use the provided src.zip to navigate the Java codebase (https://github.com/NixOS/nixpkgs/pull/95081)
      ln -s $out/lib/openjdk/lib/src.zip $out/lib/src.zip

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/linux/*_md.h $out/include/

      # Remove crap from the installation.
      rm -rf $out/lib/openjdk/demo

      ln -s $out/lib/openjdk/bin $out/bin
    '';
  }
