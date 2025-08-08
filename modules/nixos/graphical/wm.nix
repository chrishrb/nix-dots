{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.gui.enable {

    services.displayManager.sddm.enable = true; # This line enables sddm
    services.xserver.enable = true; # Might need this for Xwayland

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      dbus
      hypridle
      hyprlock
      wl-clipboard
      xdg-utils
      viewnior # Image viewr
      mako # Notifications
      libnotify # notify-send

      wofi
      playerctl
      brightnessctl

      # Gnome Stuff
      gtk-engine-murrine
      gnome-software
      gnome-disk-utility
      gnome-text-editor
      file-roller
      gnome-calculator
      nautilus # Gnome file manager
      gnome-system-monitor
    ];

    home-manager.users.${config.user} = {

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          # General
          monitor = [
            "eDP-1, preferred, 0x0, auto" # builtin display TODO: this doesnt work as expected
            "desc:Dell Inc. DELL U3415W 68MCF51S0CGL, preferred, 1920x0, auto"
            "desc:Dell Inc. DELL U2715H GH85D72K2YBS, preferred, 5360x-400, auto, transform, 3"

            ", preferred, auto, auto"
          ];

          "$terminal" = "alacritty";
          "$fileManager" = "nautilus";
          "$menu" = "wofi --show drun";
          "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier

          "exec-once" = [
            "waybar"
          ];

          "env" = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
          ];

          general = {
            "gaps_in" = "5";
            "gaps_out" = "20";
            "border_size" = "2";

            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";

            "resize_on_border" = "true";
            "allow_tearing" = "false";
            "layout" = "dwindle";
          };

          # Decoration
          decoration = {
            "rounding" = "10";
            "rounding_power" = "2";

            "active_opacity" = "1.0";
            "inactive_opacity" = "1.0";

            shadow = {
              "enabled" = "true";
              "range" = "4";
              "render_power" = "3";
              "color" = "rgba(1a1a1aee)";
            };

            blur = {
              "enabled" = "true";
              "size" = "3";
              "passes" = "1";
              "vibrancy" = "0.1696";
            };
          };

          # Animation
          animations = {
            enabled = "yes, please :)";

            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1.0"
              "quick,0.15,0,0.1,1"
            ];

            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 1, 1.94, almostLinear, fade"
              "workspacesIn, 1, 1.21, almostLinear, fade"
              "workspacesOut, 1, 1.94, almostLinear, fade"
            ];
          };

          # Workspace & window rules
          dwindle = {
            "pseudotile" = "true";
            "preserve_split" = "true";
          };

          master = {
            "new_status" = "master";
          };

          misc = {
            "force_default_wallpaper" = "-1";
            "disable_hyprland_logo" = "false";
          };

          # Keybindings
          bind = [
            "$mainMod, Q, exec, $terminal"
            "$mainMod, C, killactive,"
            "$mainMod, M, exit,"
            "$mainMod, E, exec, $fileManager"
            "$mainMod, V, togglefloating,"
            "$mainMod, R, exec, $menu"
            # "$mainMod, P, pseudo," # dwindle

            "$mainMod, H, movefocus, l"
            "$mainMod, L, movefocus, r"
            "$mainMod, K, movefocus, u"
            "$mainMod, J, movefocus, d"

            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"

            # Example special workspace (scratchpad)
            "$mainMod, S, togglespecialworkspace, magic"
            "$mainMod SHIFT, S, movetoworkspace, special:magic"

            # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"

            # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            # "$mainMod, mouse:273, resizewindow"

            # Laptop multimedia keys for volume and LCD brightness
            "$mainMod, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
            "$mainMod, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            "$mainMod, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            "$mainMod, XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            "$mainMod, XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
            "$mainMod, XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"

            # Playerctl bindings
            "$mainMod, XF86AudioNext, exec, playerctl next"
            "$mainMod, XF86AudioPause, exec, playerctl play-pause"
            "$mainMod, XF86AudioPlay, exec, playerctl play-pause"
            "$mainMod, XF86AudioPrev, exec, playerctl previous"
          ];

          # Windowrules
          windowrule = [
            # Ignore maximize requests from apps. You'll probably like this.
            "suppressevent maximize, class:.*"
            # Fix some dragging issues with XWayland
            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          ];
        };
      };
    };
  };
}
