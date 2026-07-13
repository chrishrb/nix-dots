inputs: _final: prev: {
  treesitter-kulala-http-grammar = prev.tree-sitter.buildGrammar {
    language = "kulala_http";
    version = "unstable";
    src = inputs.tree-sitter-kulala-http;
  };
}
