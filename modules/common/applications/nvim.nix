{
  lib,
  config,
  inputs,
  ...
}:

let
  nvim = import ../../common/nvim { inherit inputs; };

  mkMcpServer =
    server:
    (removeAttrs server [ "disabled" ])
    // (lib.optionalAttrs (server ? url) { type = "http"; })
    // (lib.optionalAttrs (server ? command) { type = "stdio"; })
    // {
      enabled = !(server.disabled or false);
    };

  transformedMcpServers =
    lib.optionalAttrs config.home-manager.users.${config.user}.programs.mcp.enable
      {
        mcpServers = lib.mapAttrs (
          _name: mkMcpServer
        ) config.home-manager.users.${config.user}.programs.mcp.servers;
        nativeMCPServers = {
          neovim = {
            disabled_tools = [ ];
          };
        };
      };

  mcpHubCfg = pkgs: pkgs.writeText "servers.json" (builtins.toJSON transformedMcpServers);
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
            { pkgs, ... }:
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
