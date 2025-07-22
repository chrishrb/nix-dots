{ config, pkgs, ... }:

let

  ignorePatterns = ''
    !.env*
    !.gitignore
    !*.tfvars
    .terraform/
    .target/
    /Library/'';

in
{

  config = {

    home-manager.users.${config.user} = {

      home.packages = with pkgs; [
        age # Encryption
        bc # Calculator
        dig # DNS lookup
        fd # find
        htop # Show system processes
        killall # Force quit
        inetutils # Includes telnet, whois
        jq # JSON manipulation
        rsync # Copy folders
        ripgrep # grep
        tree # View directory hierarchy
        unzip # Extract zips
        ghostscript # edit pdfs
        qpdf # split pdfs
        ffmpeg
        imagemagick # edit images
        plantuml # UML diagrams
        s3cmd # client for getting data from an s3 bucket
        unixtools.watch # watch cmd
        go-task # task runner (similar to make)
        go-grip # preview md files
        mqttx-cli # mqtt client
        xh # httpie alternative
        gh # github CLI
      ];

      home.file = {
        ".rgignore".text = ignorePatterns;
        ".digrc".text = "+noall +answer"; # Cleaner dig commands
      };

      xdg.configFile."fd/ignore".text = ignorePatterns;

    };

  };

}
