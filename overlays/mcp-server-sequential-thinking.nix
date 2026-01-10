_: _final: prev: {
  mcp-server-sequential-thinking = prev.mcp-server-sequential-thinking.overrideAttrs (old: {
    dontNpmPrune = true;
  });
}
