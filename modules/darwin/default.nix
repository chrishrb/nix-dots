{ ... }:
{
  imports = [
    ./colima
    ./homebrew.nix
    ./networking.nix
    ./system.nix
    ./user.nix
    ./trampoline.nix
    ./keyboard.nix
    ./ollama.nix
    ./mcphub.nix
  ];
}
