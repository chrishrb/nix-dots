{
  config,
  ...
}:
{

  home-manager.users.${config.user} = {
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
