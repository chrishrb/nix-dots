inputs: _final: prev: {
  glide-browser = inputs.glide.packages.${prev.system}.default;
}
