{
  description = "Basic project";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { self, nixpkgs, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "basic";
          src = self;
          # buildInputs = with pkgs; [];
          buildPhase = ''
            echo "Building..."
            mkdir -p $out/bin
            echo "#!/bin/bash" > $out/bin/hello.sh
            echo "echo Hello, world!" >> $out/bin/hello.sh
          '';
        };

        devShells.default = pkgs.mkShell {
          # buildInputs = with pkgs; [ ];
        };
      }
    );
}
