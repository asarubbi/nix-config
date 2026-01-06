# NixOS / Nix-Darwin Makefile

# --- Variables ---
HOST ?= titan

# --- Main Targets ---

.PHONY: all nixos darwin shell-dev shell-desktop clean update history

all:
	@echo "Usage: make [target]"
	@echo "  nixos HOST=<hostname>    - Rebuild NixOS configuration (default: $(HOST))"
	@echo "  darwin HOST=<hostname>   - Rebuild macOS configuration (default: $(HOST))"
	@echo "  shell-dev                - Enter dev profile shell (cross-platform)"
	@echo "  shell-desktop            - Enter desktop profile shell (cross-platform)"
	@echo "  update                   - Update flake.lock"
	@echo "  clean                    - Garbage collect old generations"
	@echo "  history                  - Show generation history"

# NixOS Rebuild
nixos:
	sudo nixos-rebuild switch --flake .#$(HOST) --impure

# macOS Rebuild (Darwin)
darwin:
	darwin-rebuild switch --flake .#$(HOST)

# Dev shells (useful on non-NixOS)
shell-dev:
	nix develop .#dev

shell-desktop:
	nix develop .#desktop

# Update Flake Inputs
update:
	nix flake update

# Garbage Collection
clean:
	nix-collect-garbage -d

# Show History
history:
	nix profile history --profile /nix/var/nix/profiles/system
