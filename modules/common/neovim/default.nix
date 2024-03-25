{ config, pkgs, lib, ... }:

let

  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.nix
    p.python
    p.rust
    p.toml
    p.typescript
    p.vue
    p.yaml
  ]));
in
{
  options.neovim.enable = lib.mkEnableOption "Neovim.";

  config = lib.mkIf config.neovim.enable {
    home-manager.users.${config.user} = {

      home.packages = with pkgs; [
        ripgrep
        fd
        lua-language-server
        rust-analyzer-unwrapped
      ];

      programs.neovim = {
        enable = true;
        package = pkgs.neovim-nightly;
        vimAlias = true;
        coc.enable = false;
        withNodeJs = true;

        plugins = [
          treesitterWithGrammars
        ];
      };

      # TODO: change
      home.file."./.config/nvim".source = config.lib.file.mkOutOfStoreSymlink "./nvim";

      # Treesitter is configured as a locally developed module in lazy.nvim
      # we hardcode a symlink here so that we can refer to it in our lazy config
      home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
        recursive = true;
        source = treesitterWithGrammars;
      };
    };
  };
}
