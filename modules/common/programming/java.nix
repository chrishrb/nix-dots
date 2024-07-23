{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.java = {
    enable = lib.mkEnableOption "Java programming language.";
    jdk = lib.mkOption {
      type = lib.types.package;
      description = "Jdk version to use";
      default = pkgs.jdk21;
    };
  };

  config = lib.mkIf config.java.enable {
    home-manager.users.${config.user}.home = {
      packages = with pkgs; [
        config.java.jdk
        maven
        gradle
        google-java-format
        jetbrains.idea-community
      ];

      # copy .ideavimrc to home directory
      file.".ideavimrc".source = ./idea/ideavimrc;
    };
  };

}
