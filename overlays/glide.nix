inputs: _final: prev: {
  glide-browser = prev.stdenv.mkDerivation rec {
    pname = "glide-browser";
    # TODO: update version each time
    version = "0.1.54a";

    src =
      let
        sources = {
          "x86_64-linux" = prev.fetchurl {
            url = "https://github.com/glide-browser/glide/releases/download/${version}/glide.linux-x86_64.tar.xz";
            sha256 = "1r8rnbgwhdqm639m5xixpw7b6v55rgjawjia5xp57g0pgyv243vr";
          };
          "aarch64-linux" = prev.fetchurl {
            url = "https://github.com/glide-browser/glide/releases/download/${version}/glide.linux-aarch64.tar.xz";
            sha256 = "0yclrk760bjyss6w466xaaqq34hfrnh98sz1xf15m1hwjxa7l4vv";
          };
          "x86_64-darwin" = prev.fetchurl {
            url = "https://github.com/glide-browser/glide/releases/download/${version}/glide.macos-x86_64.dmg";
            sha256 = "15iqc2x0d40s1kjvc0qzkyfgg6vfzbpg0y92r9asbxl2sjmwcc1w";
          };
          "aarch64-darwin" = prev.fetchurl {
            url = "https://github.com/glide-browser/glide/releases/download/${version}/glide.macos-aarch64.dmg";
            sha256 = "sha256-mLcsbUBS7cu7Al7y2iRKgW5FGMIcKAfHc0a0HwSEAfQ=";
          };
        };
      in
      sources.${prev.system};

    nativeBuildInputs = prev.lib.optionals prev.stdenv.isDarwin [ prev.undmg ];

    sourceRoot = ".";

    installPhase =
      if prev.stdenv.isLinux then
        ''
          mkdir -p $out/bin $out/lib/glide
          cp -r glide/* $out/lib/glide/
          chmod +x $out/lib/glide/glide

          cat > $out/bin/glide <<EOF
          #!/bin/sh
          cd $out/lib/glide
          exec ${prev.steam-run}/bin/steam-run ${prev.bash}/bin/bash -c "GTK_IM_MODULE=\$GTK_IM_MODULE $out/lib/glide/glide"
          EOF
          chmod +x $out/bin/glide

          cat > $out/bin/glide-browser <<EOF
          #!/bin/sh
          cd $out/lib/glide
          exec ${prev.steam-run}/bin/steam-run ${prev.bash}/bin/bash -c "GTK_IM_MODULE=\$GTK_IM_MODULE $out/lib/glide/glide"
          EOF
          chmod +x $out/bin/glide-browser
        ''
      else
        ''
          mkdir -p $out/Applications
          cp -r Glide.app $out/Applications/
        '';

    meta = {
      description = "Glide Browser";
      homepage = "https://github.com/glide-browser/glide";
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
  };
}
