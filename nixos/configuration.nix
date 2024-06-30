# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
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
#    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking
  networking = {
      hostName = "nixos";
      networkmanager.enable = true;
  };

  # time zone
  time.timeZone = "America/Los_Angeles";
#  services.automatic-timezoned.enable = true;

  # internationalisation
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
        layout = "us";
        variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable bluetooth
  hardware.bluetooth.enable = true;


  users.users = {
    ben = {
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      description = "Benjamin";
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = [
        # SSH public key(s) go here
      ];
      packages = with pkgs; [
          firefox # ensure at least a web browser
      ];
    };
  };

  environment.systemPackages = with pkgs; [
     vim
     git
     wget
     curl
     xclip
     home-manager
  ];

   programs.nix-ld.enable = true;
   programs.nix-ld.libraries = with pkgs; [
     SDL
     SDL2
     SDL2_image
     SDL2_mixer
     SDL2_ttf
     SDL_image
     SDL_mixer
     SDL_ttf
     alsa-lib
     at-spi2-atk
     at-spi2-core
     atk
     bzip2
     cairo
     cups
     curlWithGnuTls
     dbus
     dbus-glib
     desktop-file-utils
     e2fsprogs
     expat
     flac
     fontconfig
     freeglut
     freetype
     fribidi
     fuse
     fuse3
     gdk-pixbuf
     glew110
     glib
     gmp
     gst_all_1.gst-plugins-base
     gst_all_1.gst-plugins-ugly
     gst_all_1.gstreamer
     gtk2
     harfbuzz
     icu
     keyutils.lib
     libGL
     libGLU
     libappindicator-gtk2
     libcaca
     libcanberra
     libcap
     libclang.lib
     libdbusmenu
     libdrm
     libgcrypt
     libgpg-error
     libidn
     libjack2
     libjpeg
     libmikmod
     libogg
     libpng12
     libpulseaudio
     librsvg
     libsamplerate
     libthai
     libtheora
     libtiff
     libudev0-shim
     libusb1
     libuuid
     libvdpau
     libvorbis
     libvpx
     libxcrypt-legacy
     libxkbcommon
     libxml2
     mesa
     nspr
     nss
     openssl
     p11-kit
     pango
     pixman
     python3
     speex
     stdenv.cc.cc
     tbb
     udev
     vulkan-loader
     wayland
     xorg.libICE
     xorg.libSM
     xorg.libX11
     xorg.libXScrnSaver
     xorg.libXcomposite
     xorg.libXcursor
     xorg.libXdamage
     xorg.libXext
     xorg.libXfixes
     xorg.libXft
     xorg.libXi
     xorg.libXinerama
     xorg.libXmu
     xorg.libXrandr
     xorg.libXrender
     xorg.libXt
     xorg.libXtst
     xorg.libXxf86vm
     xorg.libpciaccess
     xorg.libxcb
     xorg.xcbutil
     xorg.xcbutilimage
     xorg.xcbutilkeysyms
     xorg.xcbutilrenderutil
     xorg.xcbutilwm
     xorg.xkeyboardconfig
     xz
     zlib
   ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
