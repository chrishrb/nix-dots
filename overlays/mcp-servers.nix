inputs: _final: prev: {
  mcp-server-sequential-thinking = prev.mcp-server-sequential-thinking.overrideAttrs (old: {
    dontNpmPrune = true;
  });
  mcp-grafana = inputs.nixpkgs-stable.legacyPackages.${prev.system}.mcp-grafana;
}
