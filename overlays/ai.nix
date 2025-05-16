inputs: _final: prev: {
  vectorcode = inputs.vectorcode.packages.${prev.system}.default;
}
