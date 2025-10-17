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

      home = {
        packages = with pkgs; [
          nodejs_22
          nodePackages.pnpm
          yarn
          nodePackages.ts-node
        ];

        file.".npmrc" = {
          text = lib.generators.toINIWithGlobalSection { } {
            globalSection = {
              prefix = "${config.homePath}/.npm-packages";
              "@gipedo:registry" = "https://npm.pkg.github.com/";
              "//npm.pkg.github.com/:_authToken" = "$GH_ACCESS_TOKEN";
            };
          };
          onChange = "mkdir -p ${config.homePath}/.npm-packages/lib";
        };
      };

    };

  };
}
