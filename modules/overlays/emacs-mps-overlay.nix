system: (final: prev: {
  gtkEmacsMPS = prev.emacs-git.overrideAttrs (old: {
    name = "emacs-git-mps";

    src = prev.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "ac73794b43d440d34689293f4152ea38a42bb07a";
      # sha256 = "mLTLxypbnc7UcKzRkN9tNY6/g4v+cMsTSJBUZkU/YeA=";
      sha256 = "oD8DqY9dgtsU/Iz7zuCKh2U5iTY3LlTVm9b8q8r1cns=";
    };

    buildInputs = old.buildInputs ++ [ prev.mps ];

    configureFlags = old.configureFlags ++ [
      "--disable-build-details"
      "--with-modules"
      "--with-cairo"
      "--with-xft"
      "--with-sqlite3=yes"
      "--with-compress-install"
      "--without-native-compilation"
      "--with-mailutils"
      "--with-small-ja-dic"
      "--with-tree-sitter"
      "--with-xinput2"
      "--without-xwidgets" # Needed for it to compile properly for some reason
      "--with-dbus=ifavailable"
      "--with-mps=yes"
    ];
  });
})
