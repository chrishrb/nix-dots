# INFO: these packages are buggy and don‘t work in unstable
inputs: _final: prev: {
  colima = inputs.nixpkgs-stable.legacyPackages.${prev.system}.colima;
  eslint = inputs.nixpkgs-stable.legacyPackages.${prev.system}.nodePackages.eslint;
  aws-sam-cli = inputs.nixpkgs-stable.legacyPackages.${prev.system}.aws-sam-cli;
}
