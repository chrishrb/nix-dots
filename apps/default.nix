{ system, inputs, pkgs, ... }:
{
  # helper
  default = import ./help.nix { inherit pkgs; };

  # install NixOS on a machine
  installer = import ./installer.nix { inherit pkgs; };

  # neovim
  nvim = import ./nvim.nix { inherit system inputs; };
}
