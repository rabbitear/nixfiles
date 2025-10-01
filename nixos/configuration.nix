# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    inputs.sops-nix.nixosModules.sops
    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/kreator/.config/sops/age/keys.txt";
  # ytv: vimjoyer "NixOS Secrets Management | SOPS-NIX (minute 3:33)
  sops.secrets.example-key = { };
  sops.secrets."myservice/my_subdir/my_secret" = {
    owner = config.users.users.kreator.name;
  };
  #################################
  ### From ye 'ol configuration.nix
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 1;
  };
  # Intel KVM
  boot.kernelModules = [ "kvm-intel" "fuse" "coretemp" ];


  networking.networkmanager.enable = true;
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
    displayManager.lightdm.enable = true;
    desktopManager.gnome = {
      enable = true;
    };
    xkb = {
      layout = "us";
      variant = "";
      options = "caps:ctrl_modifier";
    };
  };
  services.displayManager.autoLogin = {
    enable = true;
    user = "kreator";
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services."lightdm".enableGnomeKeyring = true;

  programs.dconf.enable = true;

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
        "org/gnome/desktop/background" = {
          picture-options = "zoom";
          primary-color = "#02023c3c8888";
          picture-uri = "file:///home/kreator/.dotfiles/wallpaper.png";
          picture-uri-dark = "file:///home/kreator/.dotfiles/wallpaper.png";
        };
        "org/gnome/desktop/wm/keybindings" = {
	      switch-to-workspace-1 = [ "<Control>1" ];
          switch-to-workspace-2 = [ "<Control>2" ];
          switch-to-workspace-3 = [ "<Control>3" ];
          switch-to-workspace-4 = [ "<Control>4" ];
	      move-to-workspace-1 = [ "<Control><Shift>1" ];
          move-to-workspace-2 = [ "<Control><Shift>2" ];
          move-to-workspace-3 = [ "<Control><Shift>3" ];
          move-to-workspace-4 = [ "<Control><Shift>4" ];
	      toggle-fullscreen = [ "<Super>F" ];
          activate-window-menu = [ "" ];
	    };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          "magnifier" = [ "<Super>Z" ];
        };
        "org/gnome/shell" = {
          enabled-extensions = [
            "no-overview@fthx"
            "ddterm@amezin.github.com"
            "appindicatorsupport@rgcjonas.gmail.com"
          ];
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
        };
      };
    }
  ];
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
  };

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };

  # Libvirt & QEMU
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;	# optimized QEMU build
      swtpm.enable = true;	# TPM emulation if needed
      ovmf.enable = true;	# UEFI firmware for VMs
    };
  };



  ### the ye 'ol conf
  #################################

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking.hostName = "hacknet";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    kreator = {
      isNormalUser = true;
      description = "Jon";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  #########################################
  ### From the good old configuration.nix
  programs.firefox.enable = true;
  # Enable network manager applet
  programs.nm-applet.enable = true;
  # dam secrets
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # For x230, Its Ivybridge CPU does not work well with vulkun
  # use ngl or opengl with GSK_RENDERER and apps will appear.
  environment.variables = {
     GSK_RENDERER = "ngl";
  };
  environment.systemPackages = with pkgs; [
    vim
    helix
    helix-gpt
    tmux
    nodejs
    bashInteractive
    adwaita-icon-theme
    gnomeExtensions.ddterm
    gnomeExtensions.appindicator
    gnomeExtensions.no-overview
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
    wl-clipboard
    #hyprmagnifier
  ];
  ### good old configuration.nix
  #########################################

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
