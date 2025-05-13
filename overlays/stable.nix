# INFO: these packages are buggy and don‘t work in unstable
inputs: _final: prev: {
  colima = inputs.nixpkgs-stable.legacyPackages.${prev.system}.colima;
  texlive = inputs.nixpkgs-stable.legacyPackages.${prev.system}.texlive;
}
