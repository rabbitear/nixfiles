# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    #./gnome.nix <- I have this in the flake.nix file
  ];

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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "kreator";
    homeDirectory = "/home/kreator";
  };

  # Add stuff for your user as youe see fit:
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
        esc = [ "collapse_selection" "keep_primary_selection" ];
      };
    };
  };

  # programs.neovim.enable = true;
  # =====
  # ktr - got this from tonybtw, oct 9, 2025
  home.packages = with pkgs; [
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
    # everything else
    rustup
    superTuxKart
    age
    mutt
    w3m
    lynx
    ncdu
    duf
    iotop
    wget
    fd
    ripgrep
    fzf
    dmenu
    bemenu
    fuzzel
    glow
    bat
    nixd
    marksman
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "rabbitear";
    userEmail = "weatchu@gmail.com";
  };
  programs.browserpass.enable = true;

  dconf.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
