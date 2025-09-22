{
  pkgs,
  config,
  lib,
  ...
}:
let 
  mcpCfg = pkgs.writeText "servers.json" ''
      {
        "mcpServers": {
          "git": {
            "autoApprove": [],
            "command": "${pkgs.mcp-server-git}/bin/mcp-server-git"
          },
          "github": {
            "url": "https://api.githubcopilot.com/mcp/",
            "autoApprove": [],
            "headers": {
              "Authorization": "Bearer ''${cmd: cat ${config.home-manager.users.${config.user}.age.secrets.github.path}}"
            }
          }
        },
        "nativeMCPServers": {
          "neovim": {
            "disabled_tools": [ ]
          }
        }
      }
    '';
  in
{

  config = lib.mkIf pkgs.stdenv.isDarwin {
    home-manager.users.${config.user}.home = {
      packages = with pkgs; [
        mcp-hub
      ];
    };

    launchd.user.agents.mcp-hub = {
      command = "${pkgs.mcp-hub}/bin/mcp-hub --config ${mcpCfg} --port 37373 --watch";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/mcp-hub.out.log";
        StandardErrorPath = "/tmp/mcp-hub.err.log";
      };
    };
  };

}
