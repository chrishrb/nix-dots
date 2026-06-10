{ config, pkgs, ... }:
{
  home-manager.users.${config.user}.programs.mcp = {
    enable = true;

    # MCP servers used in all ai tools like nvim, claude-code, ..
    servers = {
      git = {
        autoApprove = [ ];
        command = "${pkgs.mcp-server-git}/bin/mcp-server-git";
      };
      github = {
        url = "https://api.githubcopilot.com/mcp/";
        autoApprove = [ ];
        headers = {
          Authorization = "Bearer ''\${cmd: cat ${
            config.home-manager.users.${config.user}.age.secrets.github.path
          }}";
        };
      };
      context7 = {
        url = "https://mcp.context7.com/mcp";
        headers = {
          CONTEXT7_API_KEY = "''\${cmd: cat ${
            config.home-manager.users.${config.user}.age.secrets.context7.path
          }}";
        };
      };
      sequential-thinking = {
        command = "${pkgs.mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking";
      };
      chrome-devtools = {
        command = "${pkgs.chrome-devtools-mcp}/bin/chrome-devtools-mcp";
      };
      grafana = {
        command = "${pkgs.mcp-grafana}/bin/mcp-grafana";
        args = [
          "-t"
          "stdio"
        ];
        env = {
          GRAFANA_URL = "https://grafana.infrastructure.gipedo.io";
          GRAFANA_SERVICE_ACCOUNT_TOKEN = "''\${cmd: cat ${
            config.home-manager.users.${config.user}.age.secrets.grafana.path
          }}";
          GRAFANA_ORG_ID = "1";
        };
        transportType = "stdio";
      };
    };
  };
}
