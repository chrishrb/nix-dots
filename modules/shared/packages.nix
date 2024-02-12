{ pkgs }:

with pkgs; [
  # terminal, zsh, and shell-related packages
  alacritty
  fzf
  direnv
  tmuxinator

  # Cloud-related tools and SDKs
  # docker
  # docker-compose

  # Media-related packages
  # ffmpeg

  # Node.js development tools
  # nodePackages.npm # globally install npm
  # nodePackages.prettier
  # nodejs

  # Text and terminal utilities
  htop
  jq
  ripgrep
  tree
  zsh-powerlevel10k
  wget

  # programming languages
  go
  python39

  # devops
  awscli2
]
