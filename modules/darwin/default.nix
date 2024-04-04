{ ... }: {
  imports = [
    ./homebrew.nix
    ./networking.nix
    ./system.nix
    ./user.nix
    ./trampoline-apps
  ];
}
