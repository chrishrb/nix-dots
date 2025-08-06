{ pkgs, ... }:
let
  # To search for a given string inside every file with the given filename
  # (wildcards allowed) in the current directory, recursively:
  #   $ searchin filename pattern
  #
  # To search for a given string inside every file inside the current directory, recursively:
  #   $ searchin pattern
  searchin = pkgs.writeShellScriptBin "searchin" ''
    if [ -n "$2" ]; then
      find . -name "$1" -type f -exec grep -l "$2" {} \;
    else
      find . -type f -exec grep -l "$1" {} \;
    fi
  '';
in
{
  environment.systemPackages = [ searchin ];
}
