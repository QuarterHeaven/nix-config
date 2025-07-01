{
  emacsGit,
  lib,
  stdenv,
  ccacheStdenv,
  source-emacs-master-igc,
  mps,
  libgccjit,
  ...
}:
let
  source-emacs = source-emacs-master-igc;
in
(emacsGit.override {
  stdenv = ccacheStdenv;
  withPgtk = true;
  # toolkit = "lucid";
  # withCairo = false;
}).overrideAttrs
  (old: rec {
    pname = "emacs-master-pgtk-with-igc";
    name = "${pname}-${builtins.concatStringsSep "" (lib.splitString "-" source-emacs.date)}";
    inherit (source-emacs) src;
    buildInputs = old.buildInputs ++ [ mps ];
    configureFlags = old.configureFlags ++ [
      "--with-mps=yes"
    ];
    patches = (old.patches or [ ]) ++ [
      ./patches-31/fix-window-role.patch          
      ./patches-31/ns-alpha-background.patch      
      ./patches-31/ns-mac-input-source.patch      
      ./patches-31/round-undecorated-frame.patch  
      ./patches-31/system-appearance.patch
    ];
    postPatch =
      old.postPatch
      + (lib.optionalString ((old ? NATIVE_FULL_AOT) || (old ? env.NATIVE_FULL_AOT)) (
        let
          backendPath = lib.concatStringsSep " " (
            builtins.map (x: ''\"-B${x}\"'') (
              [
                # Paths necessary so the JIT compiler finds its libraries:
                "${lib.getLib libgccjit}/lib"
                "${lib.getLib libgccjit}/lib/gcc"
                "${lib.getLib stdenv.cc.libc}/lib"
              ]
              ++ lib.optionals (stdenv.cc ? cc.libgcc) [
                "${lib.getLib stdenv.cc.cc.libgcc}/lib"
              ]
              ++ [
                # Executable paths necessary for compilation (ld, as):
                "${lib.getBin stdenv.cc.cc}/bin"
                "${lib.getBin stdenv.cc.bintools}/bin"
                "${lib.getBin stdenv.cc.bintools.bintools}/bin"
              ]
            )
          );
        in
        ''
          substituteInPlace lisp/emacs-lisp/comp.el --replace-warn \
                                      "(defcustom comp-libgccjit-reproducer nil" \
                                      "(setq native-comp-driver-options '(${backendPath}))
          (defcustom comp-libgccjit-reproducer nil"
        ''
      ));
  })
