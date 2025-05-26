{
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf pkgs.stdenv.isDarwin {
    environment.systemPackages = with pkgs; [
      ollama
    ];

    launchd.user.agents.ollama-serve = {
      command = "${pkgs.ollama}/bin/ollama serve";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/ollama.out.log";
        StandardErrorPath = "/tmp/ollama.err.log";
      };
    };
  };

}
