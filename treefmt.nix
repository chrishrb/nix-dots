{ ... }:
{
  projectRootFile = "flake.nix";

  programs.nixfmt.enable = true;
  programs.stylua.enable = true;
  programs.shellcheck.enable = true;
}
