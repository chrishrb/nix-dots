{
  lib,
  config,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.ai.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        vectorcode # vectorize local code
      ];
    };

  };

}
