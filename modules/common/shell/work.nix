{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.work.enable {
    home-manager.users.${config.user} = {
      programs.zsh = {
        initContent = ''
          # source machine setup
          source ${config.homePath}/dev/work/assistant/scripts/machine-setup.sh
        '';
      };
    };
  };
}
