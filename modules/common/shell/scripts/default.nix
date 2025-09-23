{ ... }:
{
  imports = [
    ./ai-cmd.nix
    ./ai-review.nix
    ./ai-fix.nix
    ./extract.nix
    ./mktar.nix
    ./replace.nix
    ./searchin.nix
    ./urldecode.nix
    ./urlencode.nix
  ];
}
