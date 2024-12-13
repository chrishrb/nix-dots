inputs: _final: prev: {
  ai-commit = inputs.ai-commit.packages.${prev.system}.default;
  go-grip = inputs.go-grip.packages.${prev.system}.default;
}
