# Custom GNOME configuration with keybindings and appearance
{ config, pkgs, ... }:

let
  quickSearchScript = pkgs.writeShellScriptBin "quick-search" (builtins.readFile ../scripts/quick-search.sh);
  screenshotAreaScript = pkgs.writeShellScriptBin "screenshot-area" (builtins.readFile ../scripts/screenshot-area.sh);
  toggleDndScript = pkgs.writeShellScriptBin "toggle-dnd" (builtins.readFile ../scripts/toggle-do-not-disturb.sh);
  workspaceOverviewScript = pkgs.writeShellScriptBin "workspace-overview" (builtins.readFile ../scripts/workspace-overview.sh);
in
{
  # Install custom scripts
  environment.systemPackages = with pkgs; [
    quickSearchScript
    screenshotAreaScript
    toggleDndScript
    workspaceOverviewScript
    
    # Additional tools for scripts
    zenity
    jq
    gnome.gnome-screenshot
    
    # GNOME customization tools
    gnome.dconf-editor
    gnome-extension-manager
  ];

  # Configure GNOME Shell extensions
  environment.sessionVariables = {
    # Make GNOME feel less like GNOME
    GNOME_SHELL_SESSION_MODE = "user";
  };

  # Disable default GNOME apps we might not want
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome.epiphany
    gnome.geary
    gnome.totem
    gnome.yelp
  ];

  # dconf settings for GNOME customization
  programs.dconf.enable = true;
  
  # User-level dconf settings (applied via home-manager or manual setup)
  # These will need to be applied by the user after installation
  environment.etc."dconf-custom-settings.ini".text = ''
    [org/gnome/desktop/interface]
    gtk-theme='Adwaita-dark'
    color-scheme='prefer-dark'
    enable-animations=true
    cursor-theme='Adwaita'
    
    [org/gnome/desktop/wm/preferences]
    button-layout='close,minimize,maximize:'
    num-workspaces=4
    
    [org/gnome/desktop/wm/keybindings]
    close=['<Super>q']
    toggle-fullscreen=['<Super>f']
    minimize=['<Super>h']
    switch-to-workspace-1=['<Super>1']
    switch-to-workspace-2=['<Super>2']
    switch-to-workspace-3=['<Super>3']
    switch-to-workspace-4=['<Super>4']
    move-to-workspace-1=['<Super><Shift>1']
    move-to-workspace-2=['<Super><Shift>2']
    move-to-workspace-3=['<Super><Shift>3']
    move-to-workspace-4=['<Super><Shift>4']
    
    [org/gnome/settings-daemon/plugins/media-keys]
    custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']
    
    [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0]
    name='Quick Search (SearXNG)'
    command='quick-search'
    binding='<Super>s'
    
    [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1]
    name='Screenshot Area'
    command='screenshot-area'
    binding='<Super><Shift>s'
    
    [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2]
    name='Toggle Do Not Disturb'
    command='toggle-dnd'
    binding='<Super><Shift>d'
    
    [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3]
    name='Workspace Overview'
    command='workspace-overview'
    binding='<Super>w'
    
    [org/gnome/shell]
    favorite-apps=['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']
    
    [org/gnome/mutter]
    dynamic-workspaces=false
    edge-tiling=true
    
    [org/gnome/desktop/background]
    picture-options='zoom'
    primary-color='#000000'
    
    [org/gnome/desktop/screensaver]
    picture-options='zoom'
    primary-color='#000000'
  '';

  # Create a helper script to apply dconf settings
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "apply-gnome-settings" ''
      echo "Applying custom GNOME settings..."
      dconf load / < /etc/dconf-custom-settings.ini
      echo "Settings applied! You may need to restart GNOME Shell (Alt+F2, type 'r', press Enter)"
    '')
  ];
}
