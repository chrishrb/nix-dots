{ pkgs, lib, ... }:

{
  programs.fzf = {
    enable = true;
    #fuzzyCompletion = true;
    #keybindings = true;
  };
}
