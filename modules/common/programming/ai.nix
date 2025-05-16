{
  config,
  pkgs,
  lib,
  ...
}:
{

  options.ai.enable = lib.mkEnableOption "AI tools.";

  config = lib.mkIf config.ai.enable {
    home-manager.users.${config.user}.home.packages = with pkgs; [
      vectorcode # vectorize your codebase
    ];
  };

}
