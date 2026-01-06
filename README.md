# NixOS / Home Manager Configuration Overview

This repository contains my personal NixOS and Home Manager configurations, managed as a Nix flake. This `README.md` provides an overview of the module dependencies, particularly focusing on the `devbox` host, represented as a PlantUML diagram.

## Module Dependency Tree (devbox)

The following diagram illustrates the key modules and their dependencies within the `devbox` configuration. This includes external flake inputs and the local modules composing the system.

```plantuml
@startuml
skinparam componentStyle rectangle

package "Nix Flake" {
  component "flake.nix" as flake
}

package "Nix Flake Inputs" {
  component "nixpkgs" as nixpkgs_input
  component "home-manager" as hm_input
  component "nix-darwin" as darwin_input
}

package "NixOS Configurations" {
  component "nixosConfigurations.devbox" as nixos_devbox
  component "mkNixos Function" as mkNixos_fn
}

package "NixOS Modules (devbox)" {
  component "hosts/devbox/configuration.nix" as devbox_config
  component "hosts/devbox/hardware-configuration.nix" as devbox_hardware
  component "modules/nixos/i3-wm.nix" as nixos_i3
  component "NixOS programs.zsh.enable" as nixos_zsh_enable
}

package "Home Manager Modules (devbox)" {
  component "home-manager.nixosModules.home-manager" as hm_nixos_module
  component "Home Manager User Config (adsbvm)" as hm_user_config
  component "modules/home/core.nix" as hm_core
  component "modules/home/cli/default.nix" as hm_cli_default
  component "modules/home/gui/core.nix" as hm_gui_core
  component "modules/home/i3/default.nix" as hm_i3_default
}

package "Home Manager CLI Sub-Modules" {
  component "modules/home/cli/neovim.nix" as hm_cli_neovim
  component "modules/home/cli/tmux.nix" as hm_cli_tmux
  component "modules/home/cli/zsh.nix" as hm_cli_zsh
}

' Flake Dependencies
flake --> nixpkgs_input : uses
flake --> hm_input : uses
flake --> darwin_input : uses

' mkNixos Function Call
flake --> nixos_devbox : defines
nixos_devbox --> mkNixos_fn : calls

' mkNixos pulls in base config and home-manager integration
mkNixos_fn --> devbox_config : imports
devbox_config --> devbox_hardware : imports

' NixOS modules for devbox
mkNixos_fn --> nixos_i3 : includes
devbox_config --> nixos_zsh_enable : enables

' Home Manager integration into NixOS
mkNixos_fn --> hm_nixos_module : includes
hm_nixos_module --> nixpkgs_input : pulls from

' Home Manager user configuration
hm_nixos_module --> hm_user_config : configures 'adsbvm'

' Home Manager user imports
hm_user_config --> hm_core : imports
hm_user_config --> hm_cli_default : imports
hm_user_config --> hm_gui_core : imports
hm_user_config --> hm_i3_default : imports

' Home Manager CLI sub-modules
hm_cli_default --> hm_cli_neovim : imports
hm_cli_default --> hm_cli_tmux : imports
hm_cli_default --> hm_cli_zsh : imports
hm_cli_zsh --> hm_user_config : configures 'home.shell'

@enduml
```

## How to View the PlantUML Diagram

To view this diagram:

1.  **Online Viewer:** Copy the PlantUML code block above and paste it into an online PlantUML viewer (e.g., [http://www.plantuml.com/plantuml/](http://www.plantuml.com/plantuml/)).
2.  **Local Tool:** Save the code block to a file named `dependencies.puml` and use the PlantUML command-line tool or IDE plugin to render it into an image (e.g., `plantuml dependencies.puml`).
3.  **GitHub/GitLab:** These platforms often render PlantUML diagrams directly within markdown files.
