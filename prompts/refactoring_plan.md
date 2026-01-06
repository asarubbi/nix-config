# Refactor Nix Config for Multi-OS Support (NixOS, Linux, macOS)

**Objective:** 
Refactor the current Nix configuration into a modular, extensible, and composable structure that supports:
1. **NixOS:** Full system configuration.
2. **Non-NixOS Linux:** Home Manager only (e.g., Ubuntu, Mint, WSL).
3. **macOS:** Nix-Darwin + Home Manager.

**Key Requirements:**
- **Code Reuse:** "Don't Repeat Yourself" (DRY). Common CLI tools (neovim, zsh, git, etc.) should be defined once and used everywhere.
- **Opt-in Features:** Ability to easily enable/disable features like `i3` (window manager), `gnome`, or `plasma` on specific hosts.
- **Composability:** The configuration should allow mixing and matching modules (e.g., `common + i3 + nixos` vs `common + macos`).
- **Variable Usernames:** Support different usernames for different machines (e.g., `adsbvm` on NixOS, `alex` on macOS) without hardcoding a single global user.
- **Automation:** Simplify deployment commands using a `Makefile` to avoid remembering complex `nix build` flags.

## Proposed Steps

### 1. Flake Inputs
Update `flake.nix` to include `nix-darwin` as an input.

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  home-manager.url = "github:nix-community/home-manager";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";
  
  # Add darwin
  nix-darwin.url = "github:LnL7/nix-darwin";
  nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
};
```

### 2. Restructure Modules
Organize the `modules/` directory to separate concerns:

- `modules/core/`: Common configurations (shells, cli tools) applicable to *all* systems.
- `modules/home/`: Home Manager specific modules.
    - `cli/`: terminal tools (zsh, nvim, tmux).
    - `gui/`: graphical apps (kitty, browser).
    - `wm/`: window managers (i3, hyprland).
- `modules/nixos/`: NixOS-specific system modules (hardware, services, desktop environments).
- `modules/darwin/`: macOS-specific settings (system defaults, brew).

### 3. Create "Composable" Hosts
Refactor `flake.nix` outputs to build hosts by composing these modules.
Define helper functions to construct systems with variable arguments (username, host specific modules).

**Example Logic:**
- **NixOS Host (User: adsbvm):** `nixosSystem` + `modules/nixos/base.nix` + `modules/home/cli` + `modules/home/gui` + `modules/nixos/i3.nix`.
- **macOS Host (User: alex):** `darwinSystem` + `modules/darwin/base.nix` + `modules/home/cli` + `modules/home/gui`.
- **Linux Generic (User: mintuser):** `homeManagerConfiguration` + `modules/home/cli`.

### 4. Implementation Tasks

**Task 4.1: Abstract Common Home Config**
Refactor `modules/home/common.nix` -> `modules/home/core.nix`, `modules/home/cli/default.nix`, etc.

**Task 4.2: Setup Nix-Darwin**
Create `modules/darwin/base.nix` and wire it up in `flake.nix`.

**Task 4.3: Modularize i3**
Ensure `modules/nixos/i3-wm.nix` is self-contained.

**Task 4.4: Define the Outputs with Variable Users**
Rewrite the `outputs` function in `flake.nix`. Create helper functions (e.g., `mkNixos`, `mkDarwin`) that accept `username` and `modules` as arguments to avoid repetition and allow per-host customization.

**Task 4.5: Automation**
Create a `Makefile` with the following targets:
- `nixos`: Applies configuration for the current NixOS machine.
- `darwin`: Applies configuration for the current macOS machine.
- `home`: Applies Home Manager configuration.
- `up`: Updates flake inputs.
- `clean`: Garbage collects old generations.

## Instructions for Agent
"Please execute the plan above. Start by creating the new directory structure (if not already done), refactoring modules, and then implementing the flexible `flake.nix` with per-host username support. Finally, create the `Makefile`."
