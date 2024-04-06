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
      };
    };
  };
}
