{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gui.enable {
    home-manager.users.${config.user} = {

      programs.waybar = {
        enable = true;
        package = pkgs.waybar;
        settings = [
          {
            height = 20;
            layer = "top";
            modules-left = [
              "custom/launcher"
              "cpu"
              "memory"
              "hyprland/workspaces"
            ];
            modules-center = [ "mpris" ];
            modules-right = [
              "network"
              "pulseaudio"
              "backlight"
              "battery"
              "tray"
              "idle_inhibitor"
              "clock"
            ];

            "hyprland/workspaces" = {
              format = "{name}";
              all-outputs = true;
              on-click = "activate";
              format-icons = {
                active = "󱎴";
                default = "󰍹";
              };
              persistent-workspaces = {
                "1" = [ ];
                "2" = [ ];
                "3" = [ ];
                "4" = [ ];
                "5" = [ ];
                "6" = [ ];
                "7" = [ ];
                "8" = [ ];
                "9" = [ ];
              };
            };

            "tray" = {
              spacing = 10;
            };

            "clock" = {
              format = "{:%H:%M}";
              format-alt = "{:%b %d %Y}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            };

            "cpu" = {
              interval = 10;
              format = "🤖 {}%";
              max-length = 10;
            };

            "memory" = {
              interval = 30;
              format = "🧠 {}%";
              format-alt = "🧠 {used:0.1f}GB";
              max-length = 10;
            };

            "backlight" = {
              device = "intel_backlight";
              format = "{icon}";
              tooltip = true;
              format-alt = "<small>{percent}%</small>";
              format-icons = [
                "󱩎"
                "󱩏"
                "󱩐"
                "󱩑"
                "󱩒"
                "󱩓"
                "󱩔"
                "󱩕"
                "󱩖"
                "󰛨"
              ];
              on-scroll-up = "brightnessctl set 1%+";
              on-scroll-down = "brightnessctl set 1%-";
              smooth-scrolling-threshold = "2400";
              tooltip-format = "Brightness {percent}%";
            };

            "network" = {
              format-wifi = "<small>{bandwidthDownBytes}</small> {icon}";
              min-length = 10;
              fixed-width = 10;
              format-ethernet = "󰈀";
              format-disconnected = "󰤭";
              tooltip-format = "{essid}";
              interval = 1;
              # on-click = "~/.config/hypr/scripts/rofi-wifi.sh";
              format-icons = [
                "󰤯"
                "󰤟"
                "󰤢"
                "󰤥"
                "󰤨"
              ];
            };

            "pulseaudio" = {
              format = "{icon}";
              format-muted = "󰖁";
              format-icons = {
                default = [
                  ""
                  ""
                  "󰕾"
                ];
              };
              on-click = "pamixer -t";
              on-scroll-up = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+";
              on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
              on-click-right = "exec pavucontrol";
              tooltip-format = "Volume {volume}%";
            };

            "battery" = {
              bat = "BAT0";
              adapter = "ADP0";
              interval = 60;
              states = {
                warning = 15;
                critical = 7;
              };
              max-length = 20;
              format = "{icon}";
              format-warning = "{icon}";
              format-critical = "{icon}";
              format-charging = "<span font-family='Font Awesome 6 Free'></span>";
              format-plugged = "󰚥";
              format-notcharging = "󰚥";
              format-full = "󰂄";
              format-alt = "<small>{capacity}%</small>";
              format-alt-warning = "<small>{capacity}%</small>";
              format-critical-alt = "<small>{capacity}%</small>";
              format-icons = [
                "󱊡"
                "󱊢"
                "󱊣"
              ];
            };

            "mpris" = {
              format = "{player_icon} {title}";
              format-paused = " {status_icon} <i>{title}</i>";
              max-length = 80;
              player-icons = {
                default = "▶";
                mpv = "🎵";
              };
              status-icons = {
                paused = "⏸";
              };
            };

            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = " ";
                deactivated = " ";
              };
            };

            "custom/launcher" = {
              format = "󱄅";
              on-click = "wofi --show drun";
            };
          }
        ];

        style = # css
          ''
            * {
              font-family: JetBrains Mono, JetBrainsMono Nerd Font, Material Design Icons;
              font-size: 17px; 
              border: none;
              border-radius: 0;
              min-height: 0;
            }

            window#waybar {
              background-color: rgba(26, 27, 38, 0.5);          
              color: #ffffff;
              transition-property: background-color;
              transition-duration: 0.5s;
            }

            /* General styling for individual modules */
            #clock,
            #temperature,
            #mpris,
            #cpu,
            #memory,
            #tray,
            #workspaces,
            #custom-launcher {
              background-color: #222034;
              font-size: 14px;
              color: #8a909e;
              padding: 3px 8px;
              border-radius: 8px;
              margin: 8px 2px;
            }

            /* Styling for Network, Pulseaudio, Backlight, and Battery group */
            #network,
            #pulseaudio,
            #backlight,
            #battery {
              background-color: #222034;
              font-size: 20px;
              padding: 3px 8px;
              margin: 8px 0px;
            }

            /* Module-specific colors for Network, Pulseaudio, Backlight, Battery */
            #network, #pulseaudio { color: #5796E0; }
            #backlight { color: #ecd3a0; }
            #battery { 
            color: #8fbcbb;
            padding-right: 14px
            }

            /* Battery state-specific colors */
            #battery.warning { color: #ecd3a0; }
            #battery.critical:not(.charging) { color: #fb958b; }

            /* Pulseaudio mute state */
            #pulseaudio.muted { color: #fb958b; }

            /* Styling for Language, Idle Inhibitor */
            #language,
            #idle_inhibitor {
              background-color: #222034;
              color: #8a909e;
              padding: 3px 4px;
              margin: 8px 0px;
            }

            /* Rounded corners for specific group elements */
            #language { border-radius: 8px 0 0 8px; }
            #network { border-radius: 8px 0 0 8px; }
            #battery { border-radius: 0 8px 8px 0; }

            /* Temperature, CPU, and Memory colors */
            #temperature { color: #5796E0; }
            #cpu { color: #fb958b; }
            #memory { color: #a1c999; }

            /* Workspaces active button styling */
            #workspaces button {
              color: #5796E0;
              border-radius: 8px;
              box-shadow: inset 0 -3px transparent;
              padding: 3px 4px;
              transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
            }
            #workspaces button.active {
              color: #ecd3a0;
              font-weight: bold;
              border-radius: 8px;
              transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
            }

            #idle_inhibitor.activated {
              background-color: #ecf0f1;
              color: #2d3436;
              border-radius: 8px;
            }

            /* Custom launcher */
            #custom-launcher {
              color: #5796E0;
              font-size: 22px;
              padding-right: 14px;
            }

            /* Tooltip styling */
            tooltip {
              border-radius: 15px;
              padding: 15px;
              background-color: #222034;
            }
            tooltip label {
              padding: 5px;
              font-size: 14px;
              }

          '';
      };
    };

    environment.systemPackages = with pkgs; [
      brightnessctl # control brightness
      pamixer
      pavucontrol # Volume control
    ];
  };
}
