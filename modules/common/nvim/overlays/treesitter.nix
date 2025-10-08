inputs: _final: prev: {
  treesitter-kulala-http-grammar = prev.tree-sitter.buildGrammar {
    language = "kulala_http";
    version = prev.vimPlugins.kulala-nvim.version or "unstable";
    src = prev.vimPlugins.kulala-nvim;
    location = "lua/tree-sitter";
  };
}
