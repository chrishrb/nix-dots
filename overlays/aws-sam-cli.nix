inputs: _final: prev: { aws-sam-cli = inputs.nixpkgs-stable.legacyPackages.${prev.system}.aws-sam-cli; }
