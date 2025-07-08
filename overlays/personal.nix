inputs: _final: prev: {
  go-grip = inputs.go-grip.packages.${prev.system}.default;
}
