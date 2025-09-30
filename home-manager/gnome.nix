# All my Gnome3 settings.  Even if I don't use Gnome3 desktop, these are
# good to have for other gnome applications sometimes.
{ lib, config, pkgs, ... }:

{
  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings = {
        "org/gnome/desktop/interface" = {
          accent-color = "green";
        };
        "org/gnome/desktop/input-sources" = {
          xkb-options = [ "ctrl:nocaps" ];
        };
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";
	    "org/gnome/mutter".dynamic-workspaces = false;
        "org/gnome/desktop/wm/preferences".num-workspaces = "4";
        "org/gnome/desktop/wm/keybindings" = {
	      switch-to-workspace-1 = [ "<Control>1" "<Super>1" "<F1>" ];
          switch-to-workspace-2 = [ "<Control>2" "<Super>2" "<F2>" ];
          switch-to-workspace-3 = [ "<Control>3" "<Super>3" "<F3>" ];
          switch-to-workspace-4 = [ "<Control>4" "<Super>4" "<F4>" ];
	      move-to-workspace-1 = [ "<Shift>F1" ];
          move-to-workspace-2 = [ "<Shift>F2" ];
          move-to-workspace-3 = [ "<Shift>F3" ];
          move-to-workspace-4 = [ "<Shift>F4" ];
	      toggle-fullscreen = [ "<Super>F" ];
	    };
      };
    }
  ];
  
  # other gnome settings can go here.
}
