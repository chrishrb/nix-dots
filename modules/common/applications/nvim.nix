{
  lib,
  config,
  inputs,
  ...
}:

let
  nvim = import ../../common/nvim { inherit inputs; };
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
                aiProvider = config.ai.provider;
                aiModel = config.ai.model;
              };
            };
        };
      };
    };
  };
}
