# All my Gnome3 settings.  Even if I don't use Gnome3 desktop, these are
# good to have for other gnome applications sometimes.
{ lib, config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.no-overview
    gnomeExtensions.appindicator
    gnomeExtensions.ddterm 
    cheese
    iagno   # go game
    hitori  # sudoku game
    gnome-characters
  ];
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        no-overview.extensionUuid
        ddterm.extensionUuid
        appindicator.extensionUuid
      ];
    };
    #"org/gnome/shell" = {
    #  enabled-extensions = [
    #    "no-overview@fthx"
    #    "ddterm@amezin.github.com"
    #    "appindicatorsupport@rgcjonas.gmail.com"
    #  ];
    #};
    "org/gnome/desktop/interface" = {
      accent-color = "green";
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:nocaps" ];
    };
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
	"org/gnome/mutter".dynamic-workspaces = false;
    "org/gnome/desktop/wm/preferences".num-workspaces = "4";
    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      primary-color = "#02023c3c8888";
      picture-uri = "file:///home/kreator/.dotfiles/wallpaper.png";
      picture-uri-dark = "file:///home/kreator/.dotfiles/wallpaper.png";
    };
    "org/gnome/desktop/wm/keybindings" = {
      #switch-to-application-1 = mkTuple [];
      #switch-to-application-2 = pkgs.lib.mkTuple [];
      #switch-to-application-3 = pkgs.lib.mkTuple [];
      #switch-to-application-4 = pkgs.lib.mkTuple [];
	  switch-to-workspace-1 = [ "F1" ];
      switch-to-workspace-2 = [ "F2" ];
      switch-to-workspace-3 = [ "F3" ];
      switch-to-workspace-4 = [ "F4" ];
	  move-to-workspace-1 = [ "<Control><Shift>1" ];
      move-to-workspace-2 = [ "<Control><Shift>2" ];
      move-to-workspace-3 = [ "<Control><Shift>3" ];
      move-to-workspace-4 = [ "<Control><Shift>4" ];
	  toggle-fullscreen = [ "<Super>F" ];
      #activate-window-menu = pkgs.lib.mkTuple [];
      activate-window-menu = [ "<Shift><Super>M" ];
	};
    "org/gnome/settings-daemon/plugins/media-keys" = {
      #custom-keybindings = {
      #  custom0 = {
      #];
      #    binding = [ "<Super>Y" ];
      #    command = "flameshot gui";
      #    name = "Screenshot Note";
      #  };
      #  custom1 = {
      #    binding = [ "<Super>Return" ];
      #    command = "alacritty";
      #    name = "Alacritty Term";
      #  };
      #};
      magnifier = [ "<Super>Z" ];
    };
    "com/github/amezin/ddterm" = {
      ddterm-toggle-hotkey = [ "<Alt>space" ];
      bold-is-bright = false;
      background-color = "rgb(0,0,0)";
      foreground-color = "rgb(0,255,0)";
      use-system-font = false;
      use-theme-colors = false;
      custom-font = "Monospace 22";
      shortcut-window-size-inc = [ "<Alt>Down" ];
      shortcut-window-size-dec = [ "<Alt>Up" ];
      shortcut-next-tab = [ "<Alt>Right" ];
      shortcut-prev-tab = [ "<Alt>Left" ];
    };
  };
}
