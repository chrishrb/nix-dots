{
  pkgs,
  lib,
  config,
  ...
}:
let
  ai-review = pkgs.writeShellScriptBin "ai-review" ''
    set -e
    git --no-pager diff | ${pkgs.mods}/bin/mods -q -f 'perform a code review on this source. \
    	List out any logical flaws or bugs you find, ranked in order of \
    	severity with the most severe issues presented first. \
    	When you spot a bug or issue, please always suggest a remediation. \
    	Include code snippets only when necessary to understand the issue. \
    	Does the code follow common coding conventions and idioms for the \
    	language used? Does it include appropriate tests? If not, suggest \
    	initial tests that could be added.' | ${pkgs.glow}/bin/glow -p -
  '';
in
{

  config = lib.mkIf config.ai.enable {
    home-manager.users.${config.user}.home.packages = [
      ai-review
    ];
  };
}
