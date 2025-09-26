inputs: _final: prev: {
  mods = prev.mods.overrideAttrs (old: {
    version = "latest";
    src = inputs.mods;
    vendorHash = "sha256-9MNNr4mn8/D9OrQ5QVyuzvZX4hqtGdQBQkNj1oE89fI=";
  });
}
