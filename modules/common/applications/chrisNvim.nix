{ pkgs, lib, config, ... }: {

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
      home.packages = with pkgs; [ chrisNvim ];
    };
  };
}
