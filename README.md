# NixOS / nix-darwin flake (dotfiles via Stow)

This repo builds NixOS and nix-darwin systems using a few composable modules. Dotfiles are **not** managed here—clone your dotfiles repo and Stow them into `$HOME`.

What’s included:
- Shared, named package profiles in `modules/common/packages.nix` (`dev`, `desktop`, `devbox`, `titan`) reused everywhere.
- NixOS modules under `modules/nixos` (i3, NVIDIA, gaming, virtualization, printing, 1Password, etc.) plus `modules/nixos/packages.nix` to install the selected profile + fonts system-wide.
- macOS modules under `modules/darwin` with `modules/darwin/packages.nix` for the same profile + fonts.
- Flake outputs for dev shells and pre-built package profiles (`packages.<system>.<profile>`, `devShells.<system>.<profile>`) usable on any machine with Nix.

Build examples:
- NixOS: `sudo nixos-rebuild switch --flake .#titan` (uses the `titan` profile)
- macOS: `darwin-rebuild switch --flake .#macbook`
- Non-NixOS: `nix profile install .#dev` or `nix develop .#desktop` (dev/desktop shells are exported)
