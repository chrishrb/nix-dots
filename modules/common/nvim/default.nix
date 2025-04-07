{ inputs, ... }@attrs:
let

  inherit (inputs.nixCats) utils;
  inherit (inputs) nixpkgs;
  luaPath = "${./.}";
  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  extra_pkg_config = {
    allowUnfree = true;
  };
  inherit
    (forEachSystem (
      system:
      let
        dependencyOverlays = [
          (utils.standardPluginOverlay inputs)
          (import ./overlays inputs)
          # add any flake overlays here.
          #inputs.neorg-overlay.overlays.default
          #inputs.neovim-nightly-overlay.overlays.default
        ];
      in
      {
        inherit dependencyOverlays;
      }
    ))
    dependencyOverlays
    ;

  categoryDefinitions =
    {
      pkgs,
      settings,
      categories,
      name,
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
            dressing-nvim
            mini-diff
            copilot-lua
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
      extraPythonPackages = {
        test = (_: [ ]);
      };
      extraPython3Packages = {
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
    chrisNvim =
      { pkgs, ... }:
      {
        # see :help nixCats.flake.outputs.settings
        settings = {
          # will check for config in the store rather than .config
          wrapRc = true;
          configDirName = "chrishrb-nvim";
          aliases = [
            "vi"
            "vim"
            "v"
          ];
          # caution: this option must be the same for all packages.
          # nvimSRC = inputs.neovim;
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
          devops = true;
          latex = false;
          php = true;
          flutter = true;
          aiAdapter = "copilot";

          # this does not have an associated category of plugins,
          # but lua can still check for it
          lspDebugMode = false;
        };
      };
  };

  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
  defaultPackageName = "chrisNvim";
in

# see :help nixCats.flake.outputs.exports
forEachSystem (
  system:
  let
    inherit (utils) baseBuilder;
    customPackager = baseBuilder luaPath {
      inherit nixpkgs;
      inherit system dependencyOverlays extra_pkg_config;
    } categoryDefinitions;
    nixCatsBuilder = customPackager packageDefinitions;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs { inherit system; };
  in
  {
    # these outputs will be wrapped with ${system} by flake-utils.lib.eachDefaultSystem

    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one named here.
    packages = utils.mkPackages nixCatsBuilder packageDefinitions defaultPackageName;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ (nixCatsBuilder defaultPackageName) ];
        inputsFrom = [ ];
        DEVSHELL = 0;
        shellHook = ''
          exec ${pkgs.zsh}/bin/zsh
        '';
      };
    };

    # To choose settings and categories from the flake that calls this flake.
    # and you export overlays so people dont have to redefine stuff.
    inherit customPackager;
  }
)
// {

  # these outputs will be NOT wrapped with ${system}
  # this will make an overlay out of each of the packageDefinitions defined above
  # and set the default overlay to the one named here.
  overlays = utils.makeOverlays luaPath {
    # we pass in the things to make a pkgs variable to build nvim with later
    inherit nixpkgs dependencyOverlays extra_pkg_config;
    # and also our categoryDefinitions
  } categoryDefinitions packageDefinitions defaultPackageName;

  # we also export a nixos module to allow configuration from configuration.nix
  nixosModules.default = utils.mkNixosModules {
    inherit
      defaultPackageName
      dependencyOverlays
      luaPath
      categoryDefinitions
      packageDefinitions
      nixpkgs
      ;
  };
  # and the same for home manager
  homeModule = utils.mkHomeModules {
    inherit
      defaultPackageName
      dependencyOverlays
      luaPath
      categoryDefinitions
      packageDefinitions
      nixpkgs
      ;
  };
  # now we can export some things that can be imported in other
  # flakes, WITHOUT needing to use a system variable to do it.
  # and update them into the rest of the outputs returned by the
  # eachDefaultSystem function.
  inherit
    utils
    categoryDefinitions
    packageDefinitions
    dependencyOverlays
    ;
  inherit (utils) templates baseBuilder;
  keepLuaBuilder = utils.baseBuilder luaPath;
}
