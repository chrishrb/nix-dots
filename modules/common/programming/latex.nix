{
  config,
  pkgs,
  lib,
  ...
}:
{

  options.latex.enable = lib.mkEnableOption "LaTex.";

  config = lib.mkIf config.latex.enable {
    home-manager.users.${config.user}.home.packages = with pkgs; [
      texlive.combined.scheme-full
    ];
  };

}
