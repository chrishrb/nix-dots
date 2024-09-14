{ config, pkgs, lib, ... } : {

###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#  Incomplete list of macOS `defaults` commands :
#    https://github.com/yannbertrand/macos-defaults
#
###################################################################################

  config = let screenshotDirectory = "${config.homePath}/screenshots";
    in lib.mkIf pkgs.stdenv.isDarwin {

    system.stateVersion = 5;

    services.nix-daemon.enable = true;

    # This setting only applies to Darwin, different on NixOS
    nix.gc.interval = {
      Hour = 12;
      Minute = 15;
      Day = 1;
    };

    # Add ability to used TouchID for sudo authentication (with hack for tmux)
    environment = {
      etc."sudoers.d/000-sudo-touchid" = {
        text = ''
          Defaults pam_service=sudo-touchid
          Defaults pam_login_service=sudo-touchid
        '';
      };

      etc."pam.d/sudo-touchid" = {
        text = ''
          auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
          auth       sufficient     pam_tid.so
          auth       sufficient     pam_smartcard.so
          auth       required       pam_opendirectory.so
          account    required       pam_permit.so
          password   required       pam_deny.so
          session    required       pam_permit.so
        '';
      };
    };

    system = {
      # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
      activationScripts.postUserActivation.text = ''
        # activateSettings -u will reload the settings from the database and apply them to the current session,
        # so we do not need to logout and login again to make the changes take effect.
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

        if [ ! -d ${screenshotDirectory} ]; then
          echo "Create ${screenshotDirectory} directory"
          mkdir -p ~/screenshots
        fi
      '';

      defaults = {
        menuExtraClock.Show24Hour = true; # show 24 hour clock

        # customize dock
        dock = {
          tilesize = 36; # Set the icon size of Dock items to 36 pixels
          mineffect = "scale"; # Change minimize/maximize window effect
          enable-spring-load-actions-on-all-items = true; # Enable spring loading for all Dock items
          expose-animation-duration = 0.1; # Speed up Mission Control animations
          expose-group-by-app = false; # Do not group windows by application in Mission Control
          autohide = true; # automatically hide and show the dock
          autohide-time-modifier = 0.0; # Remove the auto-hiding Dock delay
          autohide-delay = 0.0; # Remove the auto-hiding Dock delay
          show-process-indicators = true; # Show indicator lights for open applications in the Dock
          show-recents = false; # do not show recent apps in dock
          showhidden = false; # Make Dock icons of hidden applications translucent
          # do not automatically rearrange spaces based on most recent use.
          mru-spaces = false;
        };

        # customize finder
        finder = {
          _FXShowPosixPathInTitle = true; # show full path in finder title
          FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
          QuitMenuItem = true; # allow quitting via ⌘ + Q; doing so will also hide desktop icons 
          ShowPathbar = true; # show path bar
          ShowStatusBar = true; # show status bar
          AppleShowAllExtensions = true; # show all file extensions
        };

        # customize trackpad
        trackpad = {
          Clicking = true; # enable tap to click
          #TrackpadRightClick = true; # enable two finger right click
          #TrackpadThreeFingerDrag = true; # enable three finger drag
        };

        ActivityMonitor = {
          IconType = 5; # Show CPU usage in Dock
          OpenMainWindow = true; # Show the main window when launching Activity Monitor
          ShowCategory = 100; # Show all processes in Activity Monitor
          SortColumn = "CPUUsage"; # Sort by CPU usage in Activity Monitor
          SortDirection = 0; # descending
        };

        # customize macOS
        NSGlobalDomain = {
          # `defaults read NSGlobalDomain "xxx"`
          "com.apple.swipescrolldirection" = true; # enable natural scrolling(default to true)
          "com.apple.sound.beep.feedback" = 0; # disable beep sound when pressing volume up/down key

          "com.apple.springing.enabled" = true; # enable springing
          "com.apple.springing.delay" = 0.0;

          # Appearance
          AppleInterfaceStyle = "Dark"; # dark mode

          AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.
          ApplePressAndHoldEnabled = false; # enable press and hold
          AppleFontSmoothing = 1; # enable font smoothing
          AppleShowScrollBars = "Always"; # always show scroll bars

          # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
          # This is very useful for vim users, they use `hjkl` to move cursor.
          # sets how long it takes before it starts repeating.
          InitialKeyRepeat = 10; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
          # sets how fast it repeats once it starts.
          KeyRepeat = 1; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)

          NSAutomaticCapitalizationEnabled = false; # disable auto capitalization
          NSAutomaticDashSubstitutionEnabled = false; # disable auto dash substitution
          NSAutomaticPeriodSubstitutionEnabled = false; # disable auto period substitution
          NSAutomaticQuoteSubstitutionEnabled = false; # disable auto quote substitution
          NSAutomaticSpellingCorrectionEnabled = false; # disable auto spelling correction

          NSUseAnimatedFocusRing = false; # Disable the over-the-top focus ring animation
          NSWindowResizeTime = 0.001; # Increase window resize speed for Cocoa applications
          NSNavPanelExpandedStateForSaveMode = true; # Expand save panel by default
          NSNavPanelExpandedStateForSaveMode2 = true;
          PMPrintingExpandedStateForPrint = true; # Expand print panel by default
          PMPrintingExpandedStateForPrint2 = true;
          NSDocumentSaveNewDocumentsToCloud = false; # Save to disk (not to iCloud) by default
          NSDisableAutomaticTermination = true; # Disable automatic termination of inactive apps
        };

        # customize settings that not supported by nix-darwin directly
        # Incomplete list of macOS `defaults` commands :
        #   https://github.com/yannbertrand/macos-defaults
        CustomUserPreferences = {
          NSGlobalDomain = {
            # Add a context menu item for showing the Web Inspector in web views
            WebKitDeveloperExtras = true;
          };
          "com.apple.finder" = {
            AppleShowAllFiles = true;
            OpenWindowForNewRemovableDisk = true;
            ShowExternalHardDrivesOnDesktop = true;
            ShowHardDrivesOnDesktop = true;
            ShowMountedServersOnDesktop = true;
            DisableAllAnimations = true; # disable all animations
            ShowRemovableMediaOnDesktop = true;
            _FXSortFoldersFirst = true;
            FXPreferredViewStyle = "Nlsv"; # Use list view in all Finder windows by default
            # When performing a search, search the current folder by default
            FXDefaultSearchScope = "SCcf";
            # Set Desktop as the default location for new Finder windows
            # For other paths, use `PfLo` and `file:///full/path/here/`
            NewWindowTarget = "PfDe";
            #NewWindowTargetPath = "file://${HOME}/Desktop/";
          };
          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.spaces" = {
            "spans-displays" = 0; # Display have seperate spaces
          };
          "com.apple.WindowManager" = {
            EnableStandardClickToShowDesktop = 0; # Click wallpaper to reveal desktop
            StandardHideDesktopIcons = 0; # Show items on desktop
            HideDesktop = 0; # Do not hide items on desktop & stage manager
            StageManagerHideWidgets = 0;
            StandardHideWidgets = 0;
          };
          "com.apple.screensaver" = {
            # Require password immediately after sleep or screen saver begins
            askForPassword = 1;
            askForPasswordDelay = 0;
          };
          "com.apple.screencapture" = {
            location = "${screenshotDirectory}";
            type = "png";
            disable-shadow = true;
          };
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
          # Prevent Photos from opening automatically when devices are plugged in
          "com.apple.ImageCapture".disableHotPlug = true;
          "com.apple.print.PrintingPrefs" = {
            "Quit When Finished" = true; # Quit printer app after print jobs complete
          };
          "com.apple.LaunchServices".LSQuarantine = false; # Disable the “Are you sure you want to open this application?” dialog
        };

        loginwindow = {
          GuestEnabled = false; # disable guest user
          SHOWFULLNAME = true; # show full name in login window
        };
      };
    };

    # Fonts
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = ["JetBrainsMono"]; })
    ];
  };
}
