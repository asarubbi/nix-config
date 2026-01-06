# NixOS / Nix-Darwin / Home-Manager Makefile

# --- Variables ---
# Default to the hostname if not provided
HOST ?= $(shell hostname)
# Default user
USER ?= adsbvm

# --- Main Targets ---

.PHONY: all nixos darwin home clean update history

all:
	@echo "Usage: make [target]"
	@echo "  nixos HOST=<hostname>    - Rebuild NixOS configuration"
	@echo "  darwin HOST=<hostname>   - Rebuild macOS configuration"
	@echo "  home USER=<username>     - Rebuild Home Manager configuration"
	@echo "  update                   - Update flake.lock"
	@echo "  clean                    - Garbage collect old generations"
	@echo "  history                  - Show generation history"

# NixOS Rebuild
nixos:
	sudo nixos-rebuild switch --flake .#$(HOST)

# macOS Rebuild (Darwin)
darwin:
	darwin-rebuild switch --flake .#$(HOST)

# Home Manager Rebuild (Standalone)
home:
	home-manager switch --flake .#$(USER)

# Update Flake Inputs
update:
	nix flake update

# Garbage Collection
clean:
	nix-collect-garbage -d

# Show History
history:
	nix profile history --profile /nix/var/nix/profiles/system
