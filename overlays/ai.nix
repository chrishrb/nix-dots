inputs: _final: prev: {
  vectorcode = inputs.vectorcode.packages.${prev.system}.default;
  mcp-hub = inputs.mcp-hub.packages.${prev.system}.default;
}
