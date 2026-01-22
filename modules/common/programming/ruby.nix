{
  config,
  lib,
  inputs,
  ...
}:
{
  options.ruby.enable = lib.mkEnableOption "Ruby programming language.";

  config = lib.mkIf config.python.enable {
    home-manager.users.${config.user}.programs.rbenv = {
      enable = true;
      plugins = [
        {
          name = "ruby-build";
          src = inputs.ruby-build;
        }
      ];
    };
  };
}
