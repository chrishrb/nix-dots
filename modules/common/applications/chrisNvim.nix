{ pkgs, lib, config, inputs, ... }: {

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

      chrisNvim = {
        enable = true;

        packages = {
          chrisNvim = { pkgs, ... }: {
            settings = {
              # will check for config in the store rather than .config
              wrapRc = true;
              configDirName = "chrishrb-nvim";
              aliases = [ "vi" "vim" ];
              # caution: this option must be the same for all packages.
              # nvimSRC = inputs.neovim;
            };
            categories = {
              lazy = true;
              generalBuildInputs = true;
              general = true;

              # languages
              go = true;
              python = true;
              web = true;
              java = true;
              devops = true;
              latex = false;

              # you could also pass something else:
              colorscheme = "catppuccin";
            };
          };
        };

      };
    };
  };
}
