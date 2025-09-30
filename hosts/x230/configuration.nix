# NixOS configuration for x230
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/searxng.nix
    ../../modules/gnome-custom.nix
  ];

  # System settings
  system.stateVersion = "24.05";

  # Networking
  networking.hostName = "x230";
  networking.networkmanager.enable = true;

  # Time zone and internationalisation
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # User configuration
  users.users.user = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
  };

  # Enable GNOME
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    firefox
    gnome.gnome-tweaks
    gnomeExtensions.dash-to-panel
    gnomeExtensions.appindicator
  ];

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
}
