{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Reports how much of the Claude Code rate limit window is left. The OAuth
  # token lives in the macOS Keychain, so this is darwin only.
  claude-usage = pkgs.writeShellApplication {
    name = "claude-usage";
    runtimeInputs = with pkgs; [
      curl
      findutils
      jq
    ];
    text = ''
      cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/claude-usage"
      cache_file="$cache_dir/usage.json"
      format="''${1:-default}"

      mkdir -p "$cache_dir"

      # The statusline redraws far more often than the numbers change, so only
      # hit the API when the cache is older than a minute. A stale cache is
      # still better than an empty statusline when the API is unreachable.
      if [ -z "$(find "$cache_file" -mmin -1 2>/dev/null)" ]; then
        token="$(/usr/bin/security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null |
          jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null || true)"

        if [ -n "$token" ]; then
          if curl -sf --max-time 5 "https://api.anthropic.com/api/oauth/usage" \
            -H "Authorization: Bearer $token" \
            -H "anthropic-beta: oauth-2025-04-20" >"$cache_file.new" 2>/dev/null &&
            jq -e '.five_hour.utilization | numbers' "$cache_file.new" >/dev/null 2>&1; then
            mv "$cache_file.new" "$cache_file"
          fi
          rm -f "$cache_file.new"
        fi
      fi

      render() {
        jq -r "$1" "$cache_file" 2>/dev/null || echo "n/a"
      }

      if [ ! -f "$cache_file" ]; then
        echo "n/a"
        exit 0
      fi

      case "$format" in
        json)
          cat "$cache_file"
          ;;
        full)
          render '"5h:\(100 - .five_hour.utilization | round)% 7d:\(100 - .seven_day.utilization | round)%"'
          ;;
        *)
          render '"\(100 - .five_hour.utilization | round)%"'
          ;;
      esac
    '';
  };
in
{
  options.claudeUsage.package = lib.mkOption {
    type = lib.types.package;
    internal = true;
    default = claude-usage;
    description = "Script reporting the remaining Claude Code usage budget.";
  };

  config = lib.mkIf (config.ai.enable && pkgs.stdenv.hostPlatform.isDarwin) {
    home-manager.users.${config.user}.home.packages = [
      claude-usage
    ];
  };
}
