# Secrets

## Rekey secrets with new ssh-keys (e.g. after adding a new host)

1. Add new user in `secrets/secrets.nix`
2. Execute `agenix -r` in the `secrets` directory
3. Rebuild the system

## Create and use secrets

1. Add new secret in `secrets/secrets.nix`
2. Create secret with `agenix -e your-name.age`
3. Use it in the config (`modules/common/applications/agenix.nix`)
4. Rebuild the system

