{
  pkgs,
  config,
  lib,
  ...
}:
let
  mcpCfg = ''
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
            "Authorization": "Bearer ''${cmd: cat ${
              config.home-manager.users.${config.user}.age.secrets.github.path
            }}"
          }
        },
        "context7": {
          "url": "https://mcp.context7.com/mcp",
          "headers": {
            "CONTEXT7_API_KEY": "''${cmd: cat ${
              config.home-manager.users.${config.user}.age.secrets.context7.path
            }}"
          }
        },
        "sequential-thinking": {
          "command": "${pkgs.sequential-thinking}/bin/mcp-server-sequential-thinking"
        },
        "aws-cdk": {
          "command": "${pkgs.cdk-mcp-server}/bin/awslabs.cdk-mcp-server",
          "env": {
            "FASTMCP_LOG_LEVEL": "ERROR"
          }
        },
        "cloudwatch": {
          "command": "${pkgs.cloudwatch-mcp-server}/bin/awslabs.cloudwatch-mcp-server",
          "env": {
            "FASTMCP_LOG_LEVEL": "ERROR"
          },
          "transportType": "stdio"
        },
        "grafana": {
          "command": "${pkgs.mcp-grafana}/bin/mcp-grafana",
          "args": [
            "-t", "stdio"
          ],
          "env": {
            "GRAFANA_URL": "https://grafana.infrastructure.gipedo.io",
            "GRAFANA_SERVICE_ACCOUNT_TOKEN": "''${cmd: cat ${
              config.home-manager.users.${config.user}.age.secrets.grafana.path
            }}",
            "GRAFANA_ORG_ID": "1"
          },
          "transportType": "stdio"
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

      file."./.config/mcphub/servers.json".text = mcpCfg;
    };

    launchd.user.agents.mcp-hub = {
      command = "${pkgs.mcp-hub}/bin/mcp-hub --config ${pkgs.writeText "servers.json" mcpCfg} --port 37373 --watch";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/mcp-hub.out.log";
        StandardErrorPath = "/tmp/mcp-hub.err.log";
      };
    };
  };

}
