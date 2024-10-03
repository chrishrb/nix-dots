{ pkgs, ... }:
{

  type = "app";

  program = builtins.toString (
    pkgs.writeShellScript "ollama" ''
      # code assistant model: deepseek-coder-v2, qwen2.5-coder, ..
      ${pkgs.ollama}/bin/ollama pull deepseek-coder-v2

      # general purpose model: mistral, qwen:7b, qwen:14b, ..
      ${pkgs.ollama}/bin/ollama pull mistral
    ''
  );
}
