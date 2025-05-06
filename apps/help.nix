{ pkgs, ... }:
{
  type = "app";

  program = builtins.toString (
    pkgs.writeShellScript "default" ''
      ${pkgs.gum}/bin/gum style --margin "1 2" --padding "0 2" --foreground "15" --background "55" "Options"
      ${pkgs.gum}/bin/gum format --type=template -- '  {{ Italic "Run with" }} {{ "  nix run github:chrisrhb/dotfiles#" }}{{ "someoption" }}.'
      echo ""
      echo ""
      ${pkgs.gum}/bin/gum format --type=template -- \
          '  • {{ Color "15" "57" " nvim " }} {{ Italic "Start nvim." }}' \
          '  • {{ Color "15" "57" " installer " }} {{ Italic "Erase disk and install NixOS on system." }}'
      echo ""
      echo ""
    ''
  );
}
