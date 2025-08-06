{ config, pkgs, ... }:
{
  config = {
    home-manager.users.${config.user}.home = {

      file."./Library/Application Support/mods/mods.yml" = {
        source = ./mods.yml;
      };

      packages = with pkgs; [
        mods # cli ai
      ];
    };
  };
}
