# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build commands

```bash
# Build and switch to the macOS nix-darwin configuration
sudo darwin-rebuild switch --flake .

# Build without switching (for testing)
sudo darwin-rebuild --flake .

# Update all flake inputs
nix flake update

# Update a specific input
nix flake update nixpkgs-unstable
```

## Architecture

This is a Nix flake that manages system configuration for macOS (via nix-darwin and home-manager) and Linux (via home-manager).

### Key Structure

- `flake.nix` — Main entry point. Defines inputs (nixpkgs-unstable, nix-darwin, home-manager, nixCats, nix-homebrew, agenix, etc.) and outputs (darwinConfigurations, nixosConfigurations, homeConfigurations, apps, devShells, checks).
- `hosts/` — Per-machine configs. Each host is a `default.nix` that selects modules/options:
  - `macbook-gipedo` — Work Mac (aarch64-darwin). Enables gui, work, ai, nvim, languages (python/go/ruby/web/devops).
  - `macbook-christoph` — Personal Mac (aarch64-darwin). Enables gui, ai, nvim, languages (python/go/web/devops).
  - `tuxedo` — Linux desktop (x86_64-linux/NixOS). Enables gui, nvim, Hyprland WM.
- `modules/` — All configuration logic, organized in three namespaces:
  - `modules/common/` — Cross-platform: shell (zsh, tmux, git, fzf, zoxide, direnv), applications (alacritty, brave, etc.), programming languages, nvim config.
  - `modules/darwin/` — macOS-specific: homebrew casks, system defaults, TouchID sudo, keyboard layout, colima, ollama, trampoline fix.
  - `modules/nixos/` — Linux-specific: Hyprland WM + waybar, hardware (audio, boot, wifi), fonts, SDDM.
- `overlays/` — Nix overlays (see Overlays section below).
- `apps/` — Runnable via `nix run .#<name>`: `nvim` (standalone neovim), `ollama` (pull models), `installer` (NixOS disk installer, Linux only).
- `secrets/` — Age-encrypted secrets via agenix (github, claude, grafana, context7 tokens).
- `templates/` — Flake templates: `basic` and `python`.
- `misc/` — Hashed password for Linux user.

### Notable Options & Flags

- `ai.enable` — Gates copilot, codecompanion, claude-code, MCP servers, copilot-usage tmux widget.
- `work.enable` — Toggles work vs personal Homebrew casks (Figma/Google Drive vs Tunnelblick/Cloudflare WARP).
- `gui.enable` — Enables GUI applications.
- Theme: **Catppuccin Mocha** used across nvim, tmux, and alacritty.

### Nvim

Neovim config lives in `modules/common/nvim/`. Packaged via **nixCats** (Nix-native plugin management) with **lazy.nvim** for load ordering.

- `default.nix` — nixCats package definition with categories (general, debug, go, python, web, java, devops, ai, etc.)
- `lua/chrishrb/config/` — Base options, keymaps, commands, icons
- `lua/chrishrb/plugins/` — lazy.nvim plugin specs + per-plugin config in `plugins/config/`
- `lua/chrishrb/lsp/` — LSP server configs (gopls, lua_ls, pylsp, ts_ls, nil/nixd, yamlls, etc.). Mason is disabled; all servers come from Nix.
- `lua/chrishrb/dap/` — Debug adapter configs (go, python, php)
- `lua/chrishrb/autocommands/` — Filetype/event autocommands
- `prompts/` — AI prompt templates for codecompanion (commit, refactor, explain, tests, etc.)
- `overlays/` — Nvim-specific overlays (vim-plugins from flake inputs, mcphub, treesitter)

Key plugins: telescope, nvim-tree, treesitter, nvim-cmp, nvim-lspconfig, trouble, fugitive, gitsigns, nvim-dap, codecompanion (AI), copilot, catppuccin theme, lualine, tmux-navigation.

## Overlays

Defined in `overlays/`, auto-composed via `default.nix`:

## Linting & CI

Pre-commit hooks enforce **nixfmt**, **stylua**, and **shellcheck**. The dev shell (`nix develop`) provides these plus shfmt and agenix. Run the formatter with `nix fmt`.

