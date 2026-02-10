inputs: _final: prev: {
  mcp-server-sequential-thinking = prev.mcp-server-sequential-thinking.overrideAttrs (old: {
    dontNpmPrune = true;
  });
  mcp-grafana = inputs.nixpkgs-stable.legacyPackages.${prev.system}.mcp-grafana;
  chrome-devtools-mcp = prev.stdenv.mkDerivation rec {
    name = "chrome-devtools-mcp";
    version = "latest";
    src = inputs.chrome-devtools-mcp;

    buildInputs = with prev; [
      nodejs_24
      cacert
    ];

    npmDeps = prev.importNpmLock {
      npmRoot = src;
    };

    buildPhase = ''
      export HOME=$TMPDIR
      npm ci
      npm run bundle
    '';

    installPhase = ''
      export HOME=$TMPDIR
      mkdir -p $out/bin
      cp build/src/index.js $out/bin/chrome-devtools-mcp
      cp -r build/src/* $out/bin/
      chmod +x $out/bin/chrome-devtools-mcp
    '';
  };
}
