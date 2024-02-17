{ pkgs, lib, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [
        pkgs.alacritty-theme.catppuccin_mocha
      ];

      cursor = {
        style = "Block";
      };

      window = {
        dynamic_title = true;
        padding = {
          x = 0;
          y = 0;
        };
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14)
        ];
        offset = {
          x = 0;
          y = 0;
        };
        glyph_offset = {
          x = 0;
          y = 0;
        };
      };
    };
  };
}
