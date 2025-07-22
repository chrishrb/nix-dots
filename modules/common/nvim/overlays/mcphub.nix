inputs: _final: prev: {
  mcp-hub = inputs.mcp-hub.packages.${prev.system}.default;
}
