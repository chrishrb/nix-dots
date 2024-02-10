{ pkgs }:

with pkgs; [
  # terminal, zsh, and shell-related packages
  alacritty
  zsh
  fzf
  direnv
  tmux
  tmuxinator

  bitwarden

  # Cloud-related tools and SDKs
  docker
  docker-compose

  # Media-related packages
  ffmpeg

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs

  # Text and terminal utilities
  htop
  jetbrains-mono
  jq
  ripgrep
  tree
  tmux
  zsh-powerlevel10k
  wget

  # Python packages
  python39
]
