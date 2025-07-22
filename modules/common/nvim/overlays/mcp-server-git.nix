inputs: _final: prev: {
  mcp-server-git = prev.python3Packages.buildPythonApplication {
    pname = "mcp-server-git";
    version = "latest";
    src = "${inputs.modelcontextprotocol-servers}/src/git";
    format = "pyproject";
    build-system = [ prev.python3Packages.hatchling ];
    propagatedBuildInputs = [
      prev.python3Packages.click
      prev.python3Packages.mcp
      prev.python3Packages.gitpython
      prev.python3Packages.pydantic
    ];
    pythonImportsCheck = [ "mcp_server_git" ];
  };
}
