with import <nixpkgs> { };

let
  ghc' = (haskellPackages.override {
    overrides = self: super: {
      jsaddle-warp =
        haskell.lib.dontCheck
          (haskell.lib.doJailbreak
            (haskell.lib.unmarkBroken super.jsaddle-warp));
      miso =
        haskell.lib.addBuildDepends
          (haskell.lib.appendConfigureFlag super.miso "-fjsaddle")
          [ self.jsaddle self.file-embed self.jsaddle-warp ];
    };
  }).ghcWithPackages (p: [ p.miso ]);
in
runCommand "miso-sample-app" {
  buildInputs = [ ghc' ];
} ""
