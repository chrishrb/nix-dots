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

  modelcontextprotocol-servers = prev.fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    rev = "f2dc09d15f2437d0cc93ac2a23c5694026434af9";
    hash = "sha256-sCPuwBsPEdd6ZhRxsCQT4sBgj04zlhqTv1030HaxVq0=";
  };
in
{
  mcp-server-git = prev.python3Packages.buildPythonApplication {
    pname = "mcp-server-git";
    version = "latest";
    src = "${modelcontextprotocol-servers}/src/git";
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
    src = modelcontextprotocol-servers;

    npmWorkspace = "src/sequentialthinking";
    # Dummy: sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=
    npmDepsHash = "sha256-GVPfXEoxACHfnXcN5HXnS2GCcKXbw0g3Bm4LuSgWyo4=";
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

  mcp-grafana = prev.buildGoModule rec {
    pname = "mcp-grafana";
    version = "0.7.8";

    src = prev.fetchFromGitHub {
      owner = "grafana";
      repo = "mcp-grafana";
      rev = "v${version}";
      hash = "sha256-NFEFPvcq6BMfwnaybAMKZEtP5kCicPr36nLOqaqsm9A=";
    };

    vendorHash = "sha256-XgbTwyiRZgq6sg3AML+RlUhnx7YTOe5VlBZq665/T6g=";
  };
}
