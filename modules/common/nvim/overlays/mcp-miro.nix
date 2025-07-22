inputs: _final: prev: {
  mcp-miro = prev.buildNpmPackage {
    pname = "mcp-miro";
    version = "latest";

    src = inputs.mcp-miro;

    # Dummy: sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=
    npmDepsHash = "sha256-kOpt6hSenPzt1865p5RNRcsLzGpuqtNePSnChcjrEJM=";

    meta = {
      description = "Miro integration for Model Context Protocol";
      homepage = "https://github.com/k-jarzyna/mcp-miro";
    };
  };
}
