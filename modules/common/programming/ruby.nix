{
  config,
  pkgs,
  lib,
  ...
}:
{

  options.ruby.enable = lib.mkEnableOption "Ruby programming language.";

  config = lib.mkIf config.ruby.enable {
    home-manager.users.${config.user}.home = {
      packages = with pkgs; [
        ruby_3_4
      ];
    };
  };
}
