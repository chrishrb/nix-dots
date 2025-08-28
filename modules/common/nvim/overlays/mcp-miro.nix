inputs: _final: prev: {
  mcp-miro = prev.buildNpmPackage {
    pname = "mcp-miro";
    version = "latest";

    src = inputs.mcp-miro;

    # Dummy: sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=
    npmDepsHash = "sha256-2MHhqoH+Cr/C3JzsDO/FzP6ZaCPkxl4mk1vUsr6i34s=";

    meta = {
      description = "Miro integration for Model Context Protocol";
      homepage = "https://github.com/k-jarzyna/mcp-miro";
    };
  };
}
