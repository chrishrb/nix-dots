{
  config,
  pkgs,
  lib,
  ...
}:
{

  options.web.enable = lib.mkEnableOption "Web.";

  config = lib.mkIf config.web.enable {
    home-manager.users.${config.user} = {

      home.packages = with pkgs; [
        nodejs_22
        nodePackages.pnpm
        yarn
        nodePackages.ts-node
      ];
    };
  };
}
