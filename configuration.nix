{
  config,
  pkgs,
  fetchgit,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nix";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.mpd = {
    enable = true;
    musicDirectory = "/home/daniel/Music";
    extraConfig = ''
      audio_output {
      	type	"pipewire"
      	name	"Pipewire Sound Server"
      }
    '';
    user = "daniel";
  };

  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  services.xserver.enable = true;
  services.xserver.autorun = false;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs (oldAttrs: {
    src = pkgs.fetchgit {
      url = "https://github.com/UntrustedAccount/dwm.git";
      rev = "1b76724cc9291f0eacf253f94fb1ee742fff4d0e";
      hash = "sha256-ltrrPMoxLGKvrDg7pMIvJ/gLvtjv9LrYMS+lTTtgBBE=";
    };

    buildInputs = (oldAttrs.buildInputs or []) ++ [pkgs.imlib2];
  });
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  users.users.daniel = {
    isNormalUser = true;
    description = "daniel";
    extraGroups = ["networkmanager" "wheel" "video"];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    acpilight
    alejandra
    dmenu
    ffmpeg_6
    feh
    firefox
    filezilla
    gcc
    gh
    git
    gnumake
    legcord
    ncmpcpp
    networkmanagerapplet
    maim
    mpc
    mpd
    pamixer
    pavucontrol
    pfetch
    playerctl
    poetry
    unzip
    vim
    vscode
    wezterm
    xclip
    yt-dlp
  ];

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.xfconf.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerdfonts
      iosevka
      jetbrains-mono
      cozette
    ];
    fontconfig = {
      defaultFonts = {
        serif = ["Liberation Serif"];
        sansSerif = ["Iosevka"];
        monospace = ["Iosevka Nerd Font Mono"];
      };
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.11";
}
