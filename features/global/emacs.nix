{ ... };
                    {
            nixpkgs.overlays = [
              emacs-overlay.overlay
              (self: super: {
                emacs-unstable = super.emacs-unstable.override {
                  withXwidgets = true;
                  withGTK3 = true;
                };
              })
            ];
          }
