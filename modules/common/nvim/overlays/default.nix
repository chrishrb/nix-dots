inputs: let 
  overlaySet = {
    nixCatsBuilds = import ./custom-plugins.nix;
  };
in
builtins.attrValues (builtins.mapAttrs (name: value: (value name inputs)) overlaySet)
