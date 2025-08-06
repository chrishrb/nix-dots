{ pkgs, ... }:
let
  # Find and replace a string in all files recursively, starting from the current directory.
  # Adapted from code found at <http://forums.devshed.com/unix-help-35/unix-find-and-replace-text-within-all-files-within-a-146179.html>
  replace = pkgs.writeShellScriptBin "replace" ''
    find . -type f | xargs perl -pi -e "s/$1/$2/g"
  '';
in
{
  environment.systemPackages = [ replace ];
}
