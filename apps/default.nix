{
  system,
  inputs,
  pkgs,
  ...
}:

let
  commonApps = {
    # Helper scripts
    default = import ./help.nix { inherit pkgs; };

    # Script to pull ollama models
    ollama = import ./ollama.nix { inherit pkgs; };

    # Neovim configuration
    nvim = import ./nvim.nix { inherit system inputs; };
  };

  linuxOnlyApps =
    if (!pkgs.stdenv.isDarwin) then
      {
        # NixOS installation utility
        installer = import ./installer.nix { inherit pkgs; };
      }
    else
      { };
in
commonApps // linuxOnlyApps
