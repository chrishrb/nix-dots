inputs: _final: prev: {
  ai-commit = inputs.ai-commit.packages.${prev.system}.default;
}
