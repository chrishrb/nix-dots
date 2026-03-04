inputs: _final: prev: {
  mcp-server-sequential-thinking = prev.mcp-server-sequential-thinking.overrideAttrs (old: {
    dontNpmPrune = true;
  });
  mcp-grafana = inputs.nixpkgs-stable.legacyPackages.${prev.system}.mcp-grafana;

  chrome-devtools-mcp = prev.buildNpmPackage {
    pname = "chrome-devtools-mcp";
    version = "0.18.1";

    src = prev.fetchFromGitHub {
      owner = "ChromeDevTools";
      repo = "chrome-devtools-mcp";
      tag = "chrome-devtools-mcp-v0.18.1";
      hash = "sha256-Tdgf3LjhSYKKZ46rfUJRQXuNjrjceezPUZfwarmlYp0=";
    };

    npmDepsHash = "sha256-zh7YYVhWwoj590nfKmoHHRt8v7+mBrsDvA7gPeKnMdE=";

    # Skip puppeteer browser download - use system Chrome
    env.PUPPETEER_SKIP_DOWNLOAD = "true";

    buildPhase = ''
      runHook preBuild
      npm run bundle
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/node_modules/chrome-devtools-mcp
      cp -r build $out/lib/node_modules/chrome-devtools-mcp/
      cp package.json $out/lib/node_modules/chrome-devtools-mcp/
      chmod +x $out/lib/node_modules/chrome-devtools-mcp/build/src/index.js
      mkdir -p $out/bin
      ln -s $out/lib/node_modules/chrome-devtools-mcp/build/src/index.js $out/bin/chrome-devtools-mcp
      runHook postInstall
    '';
  };
}
