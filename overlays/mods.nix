inputs: _final: prev: {
  mods = prev.mods.overrideAttrs (old: {
    version = "2025-09-22";

    src = prev.fetchFromGitHub {
      owner = "charmbracelet";
      repo = "mods";
      rev = "7a6ebba76caac8fad302ff4892d9a83519549243";
      sha256 = "sha256-V9PmO9SJv+kRCbntNsAD59SSeaofkqhHDwH9eqtB1OI=";
    };

    vendorHash = "sha256-9MNNr4mn8/D9OrQ5QVyuzvZX4hqtGdQBQkNj1oE89fI=";
  });
}
