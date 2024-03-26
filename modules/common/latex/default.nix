{ config, pkgs, lib, ... }: {

  options.latex.enable = lib.mkEnableOption "Latex.";

  config = lib.mkIf config.latex.enable {
    home-manager.users.${config.user}.home.packages = with pkgs; [
    ];
  };

}
