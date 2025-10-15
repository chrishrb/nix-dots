# INFO: these packages are buggy and don‘t work in unstable
inputs: _final: prev: {
  colima = inputs.nixpkgs-stable.legacyPackages.${prev.system}.colima;
  texlive = inputs.nixpkgs-stable.legacyPackages.${prev.system}.texlive;
  ollama = inputs.nixpkgs-stable.legacyPackages.${prev.system}.ollama;
  poetry = inputs.nixpkgs-stable.legacyPackages.${prev.system}.poetry;
  awscli2 = inputs.nixpkgs-stable.legacyPackages.${prev.system}.awscli2;
}
