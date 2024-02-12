self: super: {
  overlays = [
   (final: prev: {
     alacritty-theme = super.callPackage ./alacritty-theme.nix {};
   })
  ];
}
