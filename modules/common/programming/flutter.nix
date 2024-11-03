{ config, pkgs, lib, ... }: {

  options.flutter.enable = lib.mkEnableOption "Flutter framework.";

  config = lib.mkIf config.flutter.enable {
    home-manager.users.${config.user} = {
      home = {
        packages = with pkgs; [
          flutter
          cocoapods
        ];

        sessionVariables = {
          CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
        };
      };

      programs.zsh.shellAliases = {
        simulator = "open -a Simulator.app";
      };
    };
  };
}
