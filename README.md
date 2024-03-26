# nix-dots

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
    --flake github:chrishrb/nix-dots#laptop0997
```

Once installed, you can continue to update the macOS configuration:

```bash
darwin-rebuild switch --flake ~/dev/home/nix-dots
```
