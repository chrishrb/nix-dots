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
    home-manager.users.${config.user} = {
      imports = [ nvim.homeModule ];

      nvim = {
        enable = config.nvim.enable;
        packageNames = [ "nvim" ];
      };
    };
  };
}
