<br />
<div align="center">
  <a href="#">
    <img src=".github/assets/nix-dots.png" alt="Logo" height="80">
  </a>
</div>

## Getting started on macOS

To get started on a bare macOS installation, first install Nix:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Launch a new shell. Then use Nix to switch to the macOS configuration:

```bash
sudo rm /etc/bashrc
sudo rm /etc/nix/nix.conf
nix \
    --extra-experimental-features flakes \
    --extra-experimental-features nix-command \
    run nix-darwin -- switch \
    --flake github:chrishrb/nix-dots#mw
```

Once installed, you can continue to update the macOS configuration:

```bash
nix run nix-darwin -- switch --flake ".#mw"
```

Manually install the [german programming keyboard](https://github.com/MickL/macos-keyboard-layout-german-programming).
