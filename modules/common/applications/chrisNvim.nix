{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{

  options = {
    chrisNvim = {
      enable = lib.mkEnableOption {
        description = "Enable chrishrb's Neovim.";
        default = false;
      };
    };
  };

  config = lib.mkIf config.chrisNvim.enable {
    home-manager.users.${config.user} = {
      imports = [ inputs.chris-nvim.homeModule ];

      chrisNvim = (
        let
          inherit (inputs.chris-nvim) utils packageDefinitions;
        in
        {
          enable = true;
          packageNames = [ "chrisNvim" ];

          packages = {
            chrisNvim = utils.mergeCatDefs packageDefinitions.chrisNvim ({ pkgs, ... }: {
                categories = {
                  go = config.go.enable;
                  python = config.python.enable;
                  web = config.web.enable;
                  java = config.java.enable;
                  devops = config.devops.enable;
                  latex = config.latex.enable;
                  ai = config.ai.enable;
                };
              }
            );
          };

        }
      );
    };
  };
}
