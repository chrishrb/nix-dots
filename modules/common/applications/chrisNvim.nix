{
  lib,
  config,
  inputs,
  ...
}:

let
  chrisNvim = import ../../common/nvim { inherit inputs; };
in
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
      imports = [ chrisNvim.homeModule ];

      chrisNvim = {
        enable = config.chrisNvim.enable;
        packageNames = [ "chrisNvim" "chrisNvimLocalAI" ];
      };
    };
  };
}
