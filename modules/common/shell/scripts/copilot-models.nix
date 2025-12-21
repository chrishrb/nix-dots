{
  pkgs,
  lib,
  config,
  ...
}:
let
  copilot-models = pkgs.writeShellScriptBin "copilot-models" ''
    set -e
    OPENAI_API_KEY=$(${pkgs.jq}/bin/jq -r '[.[]|select(.user=="chrishrb")][0].oauth_token' ~/.config/github-copilot/apps.json)
    ${pkgs.curl}/bin/curl -s https://api.githubcopilot.com/models \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -H "Content-Type: application/json" \
      -H "Copilot-Integration-Id: vscode-chat" | ${pkgs.jq}/bin/jq -r '.data[].id'
  '';
in
{

  config = lib.mkIf config.ai.enable {
    home-manager.users.${config.user}.home.packages = [
      copilot-models
    ];
  };
}
