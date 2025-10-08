# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

### BELOW IS ORIGINAL ONE
### -- added home manager config below --
{ config, pkgs, lib, ... }:
let
  model_directory = "/mnt/westernegg/llm/ollama-models";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #<home-manager/nixos>  # 👈 add this line
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "yoshi"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.trusted-users = [ "root" "kreator" ];
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  systemd.user.services.bluetooth.serviceConfig = {
    Restart = "always";
    RestartSec = 10;
  };
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

  # Experimenting with docker
  #virtualisation.docker.enable = true;
  virtualisation.containers.enable = true;

  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;

    # Required for containers under podman-compose to be able to talk to each other
    defaultNetwork.settings.dns_enabled = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
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
  services.flatpak.enable = true;

  # Libvirt & QEMU
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;	# optimized QEMU build
      swtpm.enable = true;	# TPM emulation if needed
      ovmf.enable = true;	# UEFI firmware for VMs
    };
  };

  systemd.services.setup-ollama-models = {
    description = "Setup Ollama models directory";
    wantedBy = [ "multi-user.target" ];
    before = [ "ollama.service" ];
    script = ''
      mkdir -p ${model_directory}
      chown -R ollama:ollama ${model_directory}
      chmod 755 ${model_directory}
    '';
  };
  services.ollama = {
    enable = true;
    models = model_directory;
    host = "0.0.0.0";  # I may want to open firewall? port 11434 ?
    user = "ollama";
    group = "ollama";
    acceleration = "cuda";
    openFirewall = true;
  };
  
  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 3002;
    openFirewall = true;
  };

  # TESTING: karakeep
  services.karakeep = {
    enable = true;
    # maybe specify port, data directory, etc via extraEnvironment
    extraEnvironment = {
      PORT = "3000";
      # you may want to disable open signups
      DISABLE_SIGNUPS = "true";
    };
    browser.enable = true;
  };

  services.searx = {
    enable = true;
    package = pkgs.searxng;
    environmentFile = "/home/kreator/.searxng.env";
    redisCreateLocally = true;
    settings = {
      server = {
        #base_url = "http://yoshi:3001";
        bind_address = "0.0.0.0";
        port = 3001;
      };
      general = {
        debug = false;
        instance_name = "YoshiSearX";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
        enable_metrics = false;
      };
      ui = {
        static_use_hash = true;
        default_locale = "en";
        query_in_title = true;
        center_alignment = true;
        default_theme = "simple";
        theme_args.simple_style = "dark";
        search_on_category_select = true;
        hotkeys = "vim";
      };
      search = {
        safe_search = 2;
        autocomplete_min = 2;
        autocomplete = "duckduckgo";
        ban_time_on_fail = 5;
        max_ban_time_on_fail = 120;
      };
      # Search engines
      engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
        "duckduckgo".disabled = true;
        "brave".disabled = true;
        "bing".disabled = false;
        "mojeek".disabled = true;
        "mwmbl".disabled = false;
        "mwmbl".weight = 0.4;
        "qwant".disabled = true;
        "crowdview".disabled = false;
        "crowdview".weight = 0.5;
        "curlie".disabled = true;
        "ddg definitions".disabled = false;
        "ddg definitions".weight = 2;
        "wikibooks".disabled = false;
        "wikidata".disabled = false;
        "wikiquote".disabled = true;
        "wikisource".disabled = true;
        "wikispecies".disabled = false;
        "wikispecies".weight = 0.5;
        "wikiversity".disabled = false;
        "wikiversity".weight = 0.5;
        "wikivoyage".disabled = false;
        "wikivoyage".weight = 0.5;
        "currency".disabled = true;
        "dictzone".disabled = true;
        "lingva".disabled = true;
        "bing images".disabled = false;
        "brave.images".disabled = true;
        "duckduckgo images".disabled = true;
        "google images".disabled = false;
        "qwant images".disabled = true;
        "1x".disabled = true;
        "artic".disabled = false;
        "deviantart".disabled = false;
        "flickr".disabled = true;
        "imgur".disabled = false;
        "library of congress".disabled = false;
        "material icons".disabled = true;
        "material icons".weight = 0.2;
        "openverse".disabled = false;
        "pinterest".disabled = true;
        "svgrepo".disabled = false;
        "unsplash".disabled = false;
        "wallhaven".disabled = false;
        "wikicommons.images".disabled = false;
        "yacy images".disabled = true;
        "bing videos".disabled = false;
        "brave.videos".disabled = true;
        "duckduckgo videos".disabled = true;
        "google videos".disabled = false;
        "qwant videos".disabled = false;
        "dailymotion".disabled = true;
        "google play movies".disabled = true;
        "invidious".disabled = true;
        "odysee".disabled = true;
        "peertube".disabled = false;
        "piped".disabled = true;
        "rumble".disabled = false;
        "sepiasearch".disabled = false;
        "vimeo".disabled = true;
        "youtube".disabled = false;
        "brave.news".disabled = true;
        "google news".disabled = true;
      };
    # Enabled plugins
      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Tor check plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  security.polkit.enable = true;

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

  services.tailscale.enable = true;
  services.tailscale.interfaceName = "userspace-networking";

  nixpkgs.overlays = [
    (final: prev: {
      tailscale = prev.tailscale.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kreator = {
    isNormalUser = true;
    description = "Jon";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "bluetooth" "users" "flatpak" "podman" ];
    packages = with pkgs; [
    #  thunderbird
      flatpak
      gnome-software
    ];
  };

  users.groups.ollama = {};
  users.users.ollama = {
    isSystemUser = true;
    description = "Ollama service user";
    home = "/var/lib/ollama";
    createHome = true;
    group = "ollama";
    extraGroups = [ "users" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    # bluetooth packages
    bluez
    blueman
    libappindicator
    podman-compose
    # unix environment packages
    vim
    helix
    tmux
    nodejs
    bashInteractive
    pass
    browserpass
    rustup
    openssl
    #cargo
    #rustc
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
    qemu
    virt-manager
    virt-viewer
    xclip
    cheese
    graphviz
    gv
    bat
    glow
    tailscale
    ollama-cuda
    pciutils
    file
    gnupg
    autoconf
    procps
    util-linux
    m4
    gperf
    unzip
    linuxPackages.nvidia_x11
    libGLU
    xorg.libXi xorg.libXmu freeglut
    xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib 
    ncurses5
    stdenv.cc
    binutils
    gnumake
    gcc
    cudatoolkit
    nvidia-container-toolkit
    nvtopPackages.nvidia
    open-webui
    searxng
    nmap
    kitty
    alacritty
    niri
    lxqt.lxqt-policykit
    mpv
    openssl
    pkg-config
    dmenu
    bemenu
    sshfs
    lynx
    w3m
    gnomeExtensions.appindicator
    devenv
    mdcat
    fzf
    xdotool
    wmctrl
    alacritty
    ydotool
    foot
    kitty
    findutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
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
