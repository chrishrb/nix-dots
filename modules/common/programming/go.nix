{ config, pkgs, lib, ... }: {

  options.go.enable = lib.mkEnableOption "Go programming language.";

  config = lib.mkIf config.go.enable {
    home-manager.users.${config.user}.home = {
      packages = with pkgs; [
        go
        golangci-lint
        cobra-cli
        protobuf
      ];

      sessionPath = [ "$HOME/go/bin"];
    };

  };

}
