# INFO: these packages are buggy and don‘t work in unstable
inputs: _final: prev: {
  texlive = inputs.nixpkgs-stable.legacyPackages.${prev.system}.texlive;
  colima = inputs.nixpkgs-stable.legacyPackages.${prev.system}.colima;
  poetry = inputs.nixpkgs-stable.legacyPackages.${prev.system}.poetry;
  awscli2 = inputs.nixpkgs-stable.legacyPackages.${prev.system}.awscli2;
  tmux = inputs.nixpkgs-stable.legacyPackages.${prev.system}.tmux;
  go-grip = inputs.go-grip.packages.${prev.system}.default;
  crush = prev.crush.overrideAttrs (old: {
    doCheck = false;
  });
}
