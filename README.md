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
nix run nix-darwin -- switch --flake "."
# or
darwin-rebuild switch --flake "."
```

Or format all files:

```bash
nix fmt
```

> [!IMPORTANT]
> Deactivate all `Keyboard Shortcuts` in the macOS settings under `Keyboard -> Keyboard Shortcuts`. Otherwise some keybindings might not work.

### Activate the [German Programming Keyboard](https://github.com/MickL/macos-keyboard-layout-german-programming):

Open macOS System Settings -> Keyboard -> Text Input -> Edit -> click `+` -> click `Deutsch - Programmierung` -> click `Add`

## Cleanup old generations

```bash
sudo nix-collect-garbage -d
```

## Getting started on NixOS

Boot your machine with a live usb-stick and run

```bash
nix 
    --extra-experimental-features flakes \
    --extra-experimental-features nix-command \
    run "github:chrishrb/nix-dots#installer"
```

> [!CAUTION]
> All disks are erased and NixOS is installed

## Secrets

### Rekey secrets with new ssh-keys (e.g. after adding a new host)

1. Add new user in `secrets/secrets.nix`
2. Execute `agenix -r` in the `secrets` directory
3. Rebuild the system

### Create and use secrets

1. Add new secret in `secrets/secrets.nix`
2. Create secret with `agenix -e your-name.age`
3. Use it in the config (`modules/common/applications/agenix.nix`)
4. Rebuild the system

## Apps

```bash
# Show help
nix run "github:chrishrb/nix-dots"
```

## Templates

see [README.md](./templates)

```bash
nix flake init -t github:chrishrb/dotfiles#basic
```
