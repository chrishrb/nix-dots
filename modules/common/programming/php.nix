{
  config,
  pkgs,
  lib,
  ...
}:
{

  options.php.enable = lib.mkEnableOption "PHP programming language.";

  config = lib.mkIf config.php.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        php83
        php83Packages.composer
        jetbrains.phpstorm
      ];
    };
  };
}
