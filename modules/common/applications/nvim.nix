{
  lib,
  config,
  inputs,
  ...
}:

let
  nvim = import ../../common/nvim { inherit inputs; };

  mcpHubCfg =
    pkgs:
    pkgs.writeText "servers.json" ''
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
            "command": "${pkgs.mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking"
          },
          "chrome-devtools": {
            "command": "${pkgs.chrome-devtools-mcp}/bin/chrome-devtools-mcp"
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
  options = {
    nvim = {
      enable = lib.mkEnableOption {
        description = "Enable chrishrb's Neovim.";
        default = false;
      };
    };
  };

  config = lib.mkIf config.nvim.enable {

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home-manager.users.${config.user} = {
      imports = [ nvim.homeModule ];

      nvim = {
        enable = config.nvim.enable;
        packageNames = [ "nvim" ];

        packageDefinitions.replace = {
          nvim =
            { pkgs, name, ... }:
            {
              categories = {
                theme = config.theme;

                go = config.go.enable;
                python = config.python.enable;
                web = config.web.enable;
                java = config.java.enable;
                devops = config.devops.enable;
                latex = config.latex.enable;
                php = config.php.enable;
                ruby = config.ruby.enable;
                flutter = config.flutter.enable;

                ai = config.ai.enable;
                mcpHubCfg = mcpHubCfg pkgs;
              };
            };
        };
      };
    };
  };
}
