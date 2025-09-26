inputs: _final: prev:
let
  aws-lambda-powertools = prev.python3Packages.buildPythonApplication {
    pname = "aws-lambda-powertools";
    version = "latest";
    src = inputs.powertools-lambda-python;
    format = "pyproject";
    build-system = [ prev.python3Packages.hatchling ];
    propagatedBuildInputs = [
      prev.python3Packages.poetry-core
      prev.python3Packages.jmespath
      prev.python3Packages.typing-extensions
    ];
    pythonImportsCheck = [ "aws_lambda_powertools" ];
  };
in
{
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

  sequential-thinking = prev.buildNpmPackage {
    pname = "sequential-thinking";
    version = "latest";
    src = inputs.modelcontextprotocol-servers;
    npmWorkspace = "src/sequentialthinking";
    # Dummy: sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=
    npmDepsHash = "sha256-zFacrW1lZT4mcHRJBOVcKIJJ51kCiyGn6/ZhRVqSKAI=";
    preFixup = ''
      find $out/lib/node_modules -type l -exec sh -c '
        for f; do
          if ! [ -e "$f" ]; then
            echo "removing dangling symlink: $f"
            rm -f "$f"
          fi
        done
      ' sh {} +
    '';
    meta = {
      description = "Tool for dynamic and reflective problem-solving through a structured thinking process";
      homepage = "https://github.com/modelcontextprotocol/servers";
    };
  };

  cdk-mcp-server = prev.python3Packages.buildPythonApplication {
    pname = "cdk-mcp-server";
    version = "latest";
    src = "${inputs.awslabs-mcp}/src/cdk-mcp-server";
    format = "pyproject";
    build-system = [ prev.python3Packages.hatchling ];
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail "bs4" "beautifulsoup4"
    '';
    propagatedBuildInputs = [
      prev.python3Packages.mcp
      prev.python3Packages.pydantic
      aws-lambda-powertools
      prev.python3Packages.httpx
      prev.python3Packages.beautifulsoup4
    ];
    pythonImportsCheck = [ "awslabs" ];
  };

  cloudwatch-mcp-server = prev.python3Packages.buildPythonApplication {
    pname = "cdk-mcp-server";
    version = "latest";
    src = "${inputs.awslabs-mcp}/src/cloudwatch-mcp-server";
    format = "pyproject";
    build-system = [ prev.python3Packages.hatchling ];
    propagatedBuildInputs = [
      prev.python3Packages.boto3
      prev.python3Packages.loguru
      prev.python3Packages.mcp
      prev.python3Packages.pydantic
    ];
    pythonImportsCheck = [ "awslabs" ];
  };

  apple-mcp = prev.stdenv.mkDerivation {
    pname = "apple-mcp";
    version = "latest";
    src = inputs.apple-mcp;
    nativeBuildInputs = [
      prev.bun
    ];
    buildPhase = ''
      bun install --frozen-lockfile
      bun run build
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp dist/index.js $out/
      # wrapper script
      echo "#!${prev.runtimeShell}" > $out/bin/apple-mcp
      echo "exec ${prev.bun}/bin/bun run $out/index.js \"\$@\"" >> $out/bin/apple-mcp
      chmod +x $out/bin/apple-mcp
    '';
  };
}
