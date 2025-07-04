{ inputs, ... }@attrs:
let

  inherit (inputs.nixCats) utils;
  inherit (inputs) nixpkgs;
  luaPath = "${./.}";
  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  extra_pkg_config = {
    allowUnfree = true;
  };
  dependencyOverlays = [
    (utils.standardPluginOverlay inputs)
    (import ./overlays inputs)
    # add any flake overlays here.
    #inputs.neorg-overlay.overlays.default
    #inputs.neovim-nightly-overlay.overlays.default
  ];

  # Config for MCP Hub
  mcpHubConfig = ''
    {
      "mcpServers": {
        "git": {
          "command": "uvx",
          "args": ["mcp-server-git"]
        }
      },
      "nativeMCPServers": {
        "neovim": {
          "disabled_tools": [
            
          ]
        }
      }
    }
  '';

  categoryDefinitions =
    {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    }@packageDef:
    {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # propagatedBuildInputs:
      # this section is for dependencies that should be available
      # at BUILD TIME for plugins. WILL NOT be available to PATH
      # However, they WILL be available to the shell
      # and neovim path when using nix develop
      propagatedBuildInputs = {
        generalBuildInputs = with pkgs; [ ];
      };

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          universal-ctags
          ripgrep
          fd
          gcc
          nix-doc
          nil
          nixd
          nixfmt-rfc-style # nix
          lua-language-server
          stylua # lua
          vscode-langservers-extracted # html, css, json
          nodePackages.bash-language-server # bash
          yaml-language-server # yaml
          helm-ls # helm

          mcp-hub
          uv # python package manager
        ];
        go = with pkgs; [
          gopls
          delve
        ];
        python = with pkgs.python312Packages; [ python-lsp-server ];
        web = with pkgs; [
          nodePackages.typescript-language-server
          tailwindcss-language-server
          vue-language-server
          eslint
          nodePackages.prettier
        ];
        java = with pkgs; [ jdt-language-server ];
        devops = with pkgs; [ terraform-ls ];
        latex = with pkgs; [ texlab ];
        php = with pkgs; [ phpactor ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        lazy = with pkgs.vimPlugins; [ lazy-nvim ];
        go = with pkgs.vimPlugins; [ nvim-dap-go ];
        python = with pkgs.vimPlugins; [ nvim-dap-python ];
        java = with pkgs.vimPlugins; [ nvim-jdtls ];
        debug = with pkgs.vimPlugins; [
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
          nvim-nio
        ];
        flutter = with pkgs.vimPlugins; [ flutter-tools-nvim ];
        general = with pkgs.vimPlugins; {
          theme = catppuccin-nvim;
          ai = [
            codecompanion-nvim
            codecompanion-history-nvim
            dressing-nvim
            mini-diff
            copilot-lua
            mcphub-nvim
          ];
          look = [
            lualine-nvim
            tabline-nvim
            alpha-nvim
            nvim-web-devicons
          ];
          navigation = [
            nvim-tree-lua
            which-key-nvim
          ];
          lsp = [
            nvim-lspconfig
            hover-nvim
            none-ls-nvim
            none-ls-extras-nvim
            trouble-nvim
          ];
          cmp = [
            nvim-cmp
            cmp-buffer
            cmp-path
            cmp-cmdline
            cmp-nvim-lsp
            cmp-nvim-lsp-document-symbol

            cmp_luasnip
            luasnip
            friendly-snippets

            cmp-git
            cmp-emoji
            copilot-cmp
          ];
          core = [
            plenary-nvim
            nvim-treesitter.withAllGrammars
            nvim-ts-autotag
            telescope-nvim
            telescope-fzf-native-nvim
            vim-fugitive
            gitsigns-nvim
            vim-helm
          ];
          utils = [
            nvim-autopairs
            nvim-surround
            indent-blankline-nvim
            nvim-comment
            BufOnly-vim
            vim-bbye
            project-nvim
            mkdir-nvim
            bigfile-nvim
          ];
          custom = with pkgs.vimPlugins; [
            nvim-tmux-navigation
            gx-nvim
          ];
        };
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      optionalPlugins = {
        custom = with pkgs.nixCatsBuilds; [ ];
        gitPlugins = with pkgs.neovimPlugins; [ ];
        general = with pkgs.vimPlugins; [ ];
      };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          subtest1 = {
            CATTESTVAR = "It worked!";
          };
          subtest2 = {
            CATTESTVAR3 = "It didn't work!";
          };
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [ ''--set CATTESTVAR2 "It worked again!"'' ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages
      python3.libraries = {
        python = (
          py: [
            py.debugpy
            py.python-lsp-server
          ]
        );
      };
      extraLuaPackages = {
        test = [ (_: [ ]) ];
      };
    };

  extraJavaItems = pkgs: {
    java-test = pkgs.vscode-extensions.vscjava.vscode-java-test;
    java-debug-adapter = pkgs.vscode-extensions.vscjava.vscode-java-debug;
    lombok = pkgs.lombok;
  };

  extraPhpItems = pkgs: {
    php-debug = pkgs.vscode-extensions.xdebug.php-debug;
  };

  # packageDefinitions:

  # Now build a package with specific categories from above
  # All categories you wish to include must be marked true,
  # but false may be omitted.
  # This entire set is also passed to nixCats for querying within the lua.
  # It is directly translated to a Lua table, and a get function is defined.
  # The get function is to prevent errors when querying subcategories.

  # see :help nixCats.flake.outputs.packageDefinitions
  packageDefinitions = {
    # these also recieve our pkgs variable
    nvim =
      { pkgs, name, ... }@misc:
      {
        # see :help nixCats.flake.outputs.settings
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = true;
          aliases = [
            "vi"
            "vim"
            "v"
          ];
        };
        # see :help nixCats.flake.outputs.packageDefinitions
        categories = {
          lazy = true;
          generalBuildInputs = true;
          general = true;
          debug = true;

          # languages
          go = true;
          python = true;
          web = true;
          java = true;
          javaExtras = extraJavaItems pkgs;
          phpExtras = extraPhpItems pkgs;
          devops = true;
          latex = false;
          php = true;
          flutter = true;
          mcpHubConfigFile = "${pkgs.writeText "servers.json" mcpHubConfig}";

          # this does not have an associated category of plugins,
          # but lua can still check for it
          lspDebugMode = false;
        };
      };
  };

  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
  defaultPackageName = "nvim";
in

# see :help nixCats.flake.outputs.exports
(
  forEachSystem (
    system:
    let
      # and this will be our builder! it takes a name from our packageDefinitions as an argument, and builds an nvim.
      nixCatsBuilder = utils.baseBuilder luaPath {
        # we pass in the things to make a pkgs variable to build nvim with later
        inherit
          nixpkgs
          system
          dependencyOverlays
          extra_pkg_config
          ;
        # and also our categoryDefinitions and packageDefinitions
      } categoryDefinitions packageDefinitions;
      # call it with our defaultPackageName
      defaultPackage = nixCatsBuilder defaultPackageName;

      # this pkgs variable is just for using utils such as pkgs.mkShell
      # within this outputs set.
      pkgs = import nixpkgs { inherit system; };
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
    in
    {
      # these outputs will be wrapped with ${system} by flake-utils.lib.eachDefaultSystem

      # this will make a package out of each of the packageDefinitions defined above
      # and set the default package to the one named here.
      packages = utils.mkAllWithDefault defaultPackage;

      # choose your package for devShell
      # and add whatever else you want in it.
      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [ defaultPackage ];
          inputsFrom = [ ];
          shellHook = '''';
        };
      };
    }
  )
  // (
    let
      # we also export a nixos module to allow reconfiguration from configuration.nix
      nixosModule = utils.mkNixosModules {
        moduleNamespace = [ defaultPackageName ];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      # and the same for home manager
      homeModule = utils.mkHomeModules {
        moduleNamespace = [ defaultPackageName ];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
    in
    {

      # these outputs will be NOT wrapped with ${system}

      # this will make an overlay out of each of the packageDefinitions defined above
      # and set the default overlay to the one named here.
      overlays = utils.makeOverlays luaPath {
        inherit nixpkgs dependencyOverlays extra_pkg_config;
      } categoryDefinitions packageDefinitions defaultPackageName;

      nixosModules.default = nixosModule;
      homeModules.default = homeModule;

      inherit utils nixosModule homeModule;
      inherit (utils) templates;
    }
  )
)
