{ config, pkgs, lib, ... }: {

  options.python.enable = lib.mkEnableOption "Python programming language.";

  config = lib.mkIf config.python.enable {
    home-manager.users.${config.user}.home.packages = with pkgs; [
      python311
      poetry
      isort
      mypy
      pylint
    ];
  };

}
