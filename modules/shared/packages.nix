{ pkgs }:

with pkgs; [
  # terminal, zsh, and shell-related packages
  alacritty
  fzf
  direnv

  ghostscript
  stylua
  
  # Media-related packages
  ffmpeg

  # Text and terminal utilities
  htop
  jq
  ripgrep
  tree
  zsh-powerlevel10k
  wget

  # go
  go

  # python
  python39
  poetry

  # node
  nodejs_21
  # nodePackages.npm # globally install npm

  # devops
  awscli2
]
