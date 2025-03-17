{
  description = "Python template";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { nixpkgs, self, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.python312Packages.buildPythonApplication {
          name = "python-cli";
          src = self;
          buildInputs = with pkgs.python312Packages; [
            pip
            setuptools
            wheel
          ];
          checkInputs = with pkgs.python312Packages; [
            pytest
            arnparse
            requests-mock
          ];
          propagatedBuildInputs = with pkgs.python3Packages; [
            boto3
            requests
            urllib3
            click
          ];
        };
      }
    );
}
