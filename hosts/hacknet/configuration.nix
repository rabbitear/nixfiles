# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

### BELOW IS ORIGINAL ONE
### -- added home manager config below --
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>  # 👈 add this line
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hacknet"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "America/Anchorage";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the a Desktop Environment.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    #xkb = {
    #  layout = "us";
    #  variant = "";
    #  options = "caps:ctrl_modifier";
    #};
  };


  services.displayManager.autoLogin = {
    enable = true;
    user = "kreator";
  };

  # Intel KVM
  boot.kernelModules = [ "kvm-intel" "fuse" "coretemp" ];

  # Libvirt & QEMU
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;	# optimized QEMU build
      swtpm.enable = true;	# TPM emulation if needed
      ovmf.enable = true;	# UEFI firmware for VMs
    };
  };

  # gnome setttings daemon udev rules enable
  services.gnome.gnome-settings-daemon.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kreator = {
    isNormalUser = true;
    description = "Jon";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  home-manager.users.kreator = { pkgs, ... }: {
    home.stateVersion = "25.05"; # match your NixOS version
    programs.bash.enable = true;

    home.file.".bashrc".text = ''
      source ~/.vim/share/bin/ktr-func.sh
    '';
  };

  home-manager.backupFileExtension = "backup";

  # Install firefox.
  programs.firefox.enable = true;
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
	  switch-to-workspace-1 = [ "<Control>1" ];
          switch-to-workspace-2 = [ "<Control>2" ];
          switch-to-workspace-3 = [ "<Control>3" ];
          switch-to-workspace-4 = [ "<Control>4" ];
	  move-to-workspace-1 = [ "<Shift>F1" ];
          move-to-workspace-2 = [ "<Shift>F2" ];
          move-to-workspace-3 = [ "<Shift>F3" ];
          move-to-workspace-4 = [ "<Shift>F4" ];
	  toggle-fullscreen = [ "<Super>F" ];
	};
     };
    }
  ];
    

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    vim
    helix
    helix-gpt
    tmux
    nodejs
    bashInteractive
    adwaita-icon-theme
    gnomeExtensions.ddterm
    gnomeExtensions.appindicator
    gnome-tweaks
    gnome-software
    refine
    pass
    browserpass
    openssl
    rustup
    gcc
    git
    htop
    ncdu
    duf
    iotop
    wget
    curl
    rsync
    gnumake
    fd
    unzip
    ripgrep
    zip
    fzf
    jq
    yq
    dmenu
    bemenu
    qemu
    virt-manager
    virt-viewer
    xclip
    graphviz
    gv
    kitty
    alacritty
    bat
    glow
    abduco
    dvtm
    file
    tree
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.yazi.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
