# INFO: catppuccin tmux changed a lot in the v2.x.x release and doesnt work anymore like before
inputs: _final: prev: {
  tmuxPlugins = prev.tmuxPlugins // {
    catppuccin = prev.tmuxPlugins.mkTmuxPlugin {
      pluginName = "catppuccin";
      version = "unstable-2024-05-15";
      src = prev.fetchFromGitHub {
        owner = "catppuccin";
        repo = "tmux";
        rev = "697087f593dae0163e01becf483b192894e69e33";
        hash = "sha256-EHinWa6Zbpumu+ciwcMo6JIIvYFfWWEKH1lwfyZUNTo=";
      };
      postInstall = ''
        sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
      '';
      meta = with prev.lib; {
        homepage = "https://github.com/catppuccin/tmux";
        description = "Soothing pastel theme for Tmux!";
        license = licenses.mit;
        platforms = platforms.unix;
        maintainers = with maintainers; [ jnsgruk ];
      };
    };
  };
}
