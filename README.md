# nixfiles
My Nix files - its like the rockford files, but its with Nix.

## Features

- **Custom GNOME Desktop**: Heavily customized GNOME3 environment with custom keybindings and scripts
- **SearXNG**: Private search engine running on localhost:3001
- **ThinkPad x230**: Optimized configuration for ThinkPad x230 laptop
- **Custom Scripts**: Quick search, screenshots, and workspace management

## Installation

1. Clone this repository to your NixOS system
2. Update hardware configuration if needed in `hosts/x230/hardware-configuration.nix`
3. Build and switch to the configuration:

```bash
sudo nixos-rebuild switch --flake .#x230
```

## Custom Keybindings

After installation, apply custom GNOME settings:

```bash
apply-gnome-settings
```

Then restart GNOME Shell (Alt+F2, type 'r', press Enter) or log out and back in.

### Keybindings

- **Super+s**: Quick search using SearXNG
- **Super+Shift+s**: Screenshot selected area
- **Super+Shift+d**: Toggle Do Not Disturb
- **Super+w**: Workspace overview
- **Super+q**: Close window
- **Super+f**: Toggle fullscreen
- **Super+h**: Minimize window
- **Super+1-4**: Switch to workspace 1-4
- **Super+Shift+1-4**: Move window to workspace 1-4

## SearXNG

SearXNG is automatically started on system boot and listens on `http://localhost:3001`.

You can access it directly in your browser or use the quick search shortcut (Super+s).

## Custom Scripts

Custom scripts are available in `/run/current-system/sw/bin/`:
- `quick-search`: Quick search dialog for SearXNG
- `screenshot-area`: Take screenshot of selected area
- `toggle-dnd`: Toggle Do Not Disturb mode
- `workspace-overview`: Show workspace overview

## Adding Other Machines

To add a new machine configuration:

1. Create a new directory in `hosts/` (e.g., `hosts/newmachine/`)
2. Add `configuration.nix` and `hardware-configuration.nix`
3. Add the configuration to `flake.nix`:

```nix
nixosConfigurations.newmachine = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [ ./hosts/newmachine/configuration.nix ];
};
```

## Customization

- **GNOME settings**: Edit `modules/gnome-custom.nix`
- **SearXNG settings**: Edit `modules/searxng.nix`
- **Scripts**: Edit files in `scripts/` directory
- **Packages**: Add to `environment.systemPackages` in `hosts/x230/configuration.nix`

## Notes

- The GNOME configuration tries to make GNOME3 feel completely different with custom keybindings and appearance
- All machines can share the same base configuration with machine-specific overrides
- SearXNG secret key should be changed in production (see `modules/searxng.nix`)
