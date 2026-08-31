# INFO: tmux >= 3.7 refuses to configure on darwin unless jemalloc is explicitly
# enabled or disabled (macOS calloc(3) may not zero allocations). Upstream
# nixpkgs doesn't pass the flag yet, so do it here — jemalloc is the variant
# tmux recommends.
_: _final: prev:
prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
  tmux = prev.tmux.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ prev.jemalloc ];
    configureFlags = (old.configureFlags or [ ]) ++ [ "--enable-jemalloc" ];
  });
}
