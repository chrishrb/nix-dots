{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    alacritty = {
      enable = lib.mkEnableOption {
        description = "Enable Alacritty.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.alacritty.enable) {
    home-manager.users.${config.user} = {

      programs.alacritty = {
        enable = true;
        settings = {
          general.import = [
            pkgs.alacritty-theme."catppuccin_${config.theme}"
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

          keyboard.bindings = [
            {
              key = "S";
              mods = "Alt";
              chars = "\\u001bs";
            }
            {
              key = "E";
              mods = "Alt";
              chars = "\\u001be";
            }
          ];
        };
      };
    };
  };
}
