{ config, pkgs, lib, ... }: {

  options.nixlang.enable = lib.mkEnableOption "Nix programming language.";

  config = lib.mkIf config.nixlang.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        nixfmt-rfc-style # Nix file formatter
      ];
    };
  };
}
