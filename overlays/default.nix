inputs:
let
  lib = inputs.nixpkgs.lib;

  overlayFiles = builtins.filter (name: name != "default.nix") (
    builtins.attrNames (builtins.readDir ./.)
  );

  overlays = builtins.map (file: import (./. + "/${file}") inputs) overlayFiles;

in
lib.composeManyExtensions overlays
