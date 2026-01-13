inputs: _final: prev:
let
  cache = prev.writeShellScriptBin "cache" ''
    set -e

    original_args=$*

    usage() {
    	echo "usage: cache [--ttl SECONDS] [--cache-status CACHEABLE-STATUSES] [--stale_while_revalidate SECONDS] [cache-key] [command] [args for command]"
    	echo "	--ttl                     # Treat previously cached content as fresh if fewer than SECONDS seconds have passed"
    	echo "	--cache-status            # Quoted and space-delimited exit statuses for [command] that are acceptable to cache."
    	echo "	--check                   # Returns 0 if the content is cached and 1 if content is uncached or the TTL/SWR conditions are unmet."
    	echo "	--purge                   # Remove any cached content at [cache-key]"
    	echo "	--stale-while-revalidate  # Serve stale content for SECONDS past TTL while updating in the background"
    	echo "	--help                    # show this help documentation"
    }

    while [[ $# -gt 0 ]]
    do
    	key="$1"

    	case $key in
    		--cache-status)
    			acceptable_statuses="$2"
    			shift # drop the key
    			shift # drop the value
    			;;
    		--check)
    			check_only=0
    			shift; # drop the key
    			;;
    		--force-stale)
    			force_stale=1
    			shift # drop the key
    			;;
    		--help)
    			usage
    			exit 0
    			;;
    		--purge)
    			purge=0
    			shift # drop the key
    			;;
    		--stale-while-revalidate)
    			stale_while_revalidate="$2"
    			shift # drop the key
    			shift # drop the value
    			;;
    		--ttl)
    			ttl="$2"
    			shift # drop the key
    			shift # drop the value
    			;;
    		--)
    			cache_key=$2
    			shift # drop the --
    			shift # drop the cache key
    			break
    			;;
    		*) # default
    			if [ -z "$cache_key" ]; then
    				cache_key=$1
    				shift
    			else
    				break;
    			fi
    			;;
    	esac
    done

    if [ -z "$cache_key" ]; then
    	echo "Error: You must provide a cache key and command"
    	exit 64
    fi

    cache_dir=''${CACHE_DIR:-$TMPDIR}
    cache_file="$cache_dir$cache_key"

    if [ -n "$purge" ]; then
    	if [ -f "$cache_file" ]; then
    		rm "$cache_file"
    	fi
    	exit 0
    fi

    if [ -z "$1" ] && [ -z "$check_only" ]; then
    	echo "Error: You must provide a command"
    	exit 64
    fi

    fresh () {
    	# if the $cache_file doesn't exist, it can't be fresh
    	if [ ! -f "$cache_file" ]; then
    		return 1
    	fi

    	# if we don't have a ttl specifed, our $cache_file is
    	# fresh-enough
    	if [ -z "$ttl" ]; then
    		return 0
    	fi

    	# if a ttl is specified, we need to check the last modified
    	# timestamp on the $cache_file
    	mtime=$(${prev.coreutils}/bin/stat -c %Y "$cache_file")

    	now=$(date +%s)
    	remaining_time=$((now - mtime))

    	if [ $remaining_time -lt "$ttl" ]; then
    		return 0
    	fi

    	if [ $remaining_time -lt $((ttl + stale_while_revalidate)) ]; then
    		update_in_background=1
    		return 0
    	fi

    	return 1
    }

    if [ -z "$force_stale" ] && fresh; then
    	[ -n "$check_only" ] && exit 0

    	if status=$(cat  2> /dev/null "$cache_file.cache-status"); then
    		cat "$cache_file"
    	else
    		rm "$cache_file"
    		echo "No .cache-status file was found. Please re-run your command."
    		exit 1
    	fi
    else
    	[ -n "$check_only" ] && exit 1

    	"$@" | tee "$cache_file"
    	status=''${PIPESTATUS[0]}

    	acceptable_statuses=''${acceptable_statuses: -0}
    	if [[ $acceptable_statuses != "*" ]] && [[ ! " $acceptable_statuses " = *" $status "* ]]; then
    		rm "$cache_file"
    	else
    		echo "$status" > "$cache_file.cache-status"
    	fi
    fi

    if [ "$update_in_background" = "1" ]; then
    	# We re-run the original command with the original args + --force-stale to
    	# prevent the possibility of leveraging --stale-while-revalidate again.
    	#
    	# the & puts this in the background
    	# the > /dev/null mean the STDOUT of the command won't show up in the
    	# current script's output
    	#
    	#
    	# shellcheck disable=SC2086
    	''${BASH_SOURCE[0]} --force-stale $original_args > /dev/null &
    fi

    exit "$status"
  '';

  copilot-usage = prev.writeShellScriptBin "copilot-usage" ''
    set -e

    USER_AGENT="Copilot-Stats-Script"
    API_USER="https://api.github.com/copilot_internal/user"
    API_TOKEN="https://api.github.com/copilot_internal/v2/token"

    ###############################################################################
    # Find config path (mirrors Lua logic)
    ###############################################################################
    find_config_path() {
      if [ -n "$CODECOMPANION_TOKEN_PATH" ]; then
        echo "$CODECOMPANION_TOKEN_PATH"
        return
      fi

      if [ -n "$XDG_CONFIG_HOME" ] && [ -d "$XDG_CONFIG_HOME" ]; then
        echo "$XDG_CONFIG_HOME"
        return
      fi

      if [ "$(uname -s | ${prev.coreutils}/bin/tr '[:upper:]' '[:lower:]')" = "windows_nt" ] &&
         [ -d "$HOME/AppData/Local" ]; then
        echo "$HOME/AppData/Local"
        return
      fi

      if [ -d "$HOME/.config" ]; then
        echo "$HOME/.config"
        return
      fi
    }

    ###############################################################################
    # Get OAuth token
    ###############################################################################
    get_oauth_token() {
      # Codespaces shortcut
      if [ -n "$GITHUB_TOKEN" ] && [ -n "$CODESPACES" ]; then
        echo "$GITHUB_TOKEN"
        return
      fi

      config_path="$(find_config_path)"
      [ -z "$config_path" ] && return 1

      for file in \
        "$config_path/github-copilot/hosts.json" \
        "$config_path/github-copilot/apps.json"
      do
        if [ -f "$file" ]; then
          token="$(${prev.jq}/bin/jq -r '
            to_entries[]
            | select(.key | contains("github.com"))
            | .value.oauth_token
          ' "$file" 2>/dev/null | ${prev.coreutils}/bin/head -n1)"

          if [ -n "$token" ] && [ "$token" != "null" ]; then
            echo "$token"
            return
          fi
        fi
      done

      return 1
    }

    ###############################################################################
    # Get Copilot token
    ###############################################################################
    get_copilot_token() {
      oauth_token="$1"

      response="$(${prev.curl}/bin/curl -s \
        -H "Authorization: Bearer $oauth_token" \
        -H "Accept: application/json" \
        -H "User-Agent: $USER_AGENT" \
        "$API_TOKEN")"

      echo "$response" | ${prev.jq}/bin/jq -r '.token // empty'
    }

    ###############################################################################
    # Main
    ###############################################################################
    oauth_token="$(get_oauth_token || true)"
    if [ -z "$oauth_token" ]; then
      echo "Error: Could not find GitHub OAuth token"
      exit 1
    fi

    copilot_token="$(get_copilot_token "$oauth_token")"
    if [ -z "$copilot_token" ]; then
      echo "Error: Could not authorize Copilot token"
      exit 1
    fi

    stats="$(${prev.curl}/bin/curl -s \
      -H "Authorization: Bearer $oauth_token" \
      -H "Accept: */*" \
      -H "User-Agent: $USER_AGENT" \
      "$API_USER")"

    entitlement="$(echo "$stats" | ${prev.jq}/bin/jq -r '.quota_snapshots.premium_interactions.entitlement // 0')"
    remaining="$(echo "$stats" | ${prev.jq}/bin/jq -r '.quota_snapshots.premium_interactions.remaining // 0')"

    if [ "$entitlement" -eq 0 ]; then
      echo "No premium entitlement found"
      exit 1
    fi

    used=$((entitlement - remaining))
    usage_percent="$(${prev.gawk}/bin/awk "BEGIN { printf \"%.1f\", ($used / $entitlement) * 100 }")"

    echo "$usage_percent%"
  '';
in
{
  copilot-usage-cached = prev.writeShellScriptBin "copilot-usage-cached" ''
    ${cache}/bin/cache --ttl 3600 copilot-usage-key \
      ${copilot-usage}/bin/copilot-usage
  '';
}
