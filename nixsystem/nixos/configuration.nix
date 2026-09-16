# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "MikuTeto"; # Define your hostname.

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
  	pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;
   };

  hardware.bluetooth = {
	enable = true;
	powerOnBoot = false;
  };

  services.dunst.enable = true;
  services.displayManager.sddm.enable = true;

  services.xserver = {
	enable = true;

	windowManager.i3 = {
		enable = true;
		extraPackages = with pkgs; [
			dmenu
			rofi
			i3status
			i3lock
			feh
			picom
		];
	};
  };

  programs.fish = {
   enable = true;
   shellAliases = {
	nixrebuild = "sudo nixos-rebuild switch --flake ~/nixsystem/#MikuTeto";
    ls="eza -al --color=always --group-directories-first --icons=always"; # preferred listing
    la="eza -a --color=always --group-directories-first --icons=always";  # all files and dirs
    ll="eza -l --color=always --group-directories-first --icons=always";  # long format
    lt="eza -aT --color=always --group-directories-first --icons=always"; # tree listing
    "l."="eza -a | grep -e '^\.'";                                     # show only dotfiles
};

  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."sandil" = {
    isNormalUser = true;
    description = "sandil kosgahakumbura";
    extraGroups = [ "networkmanager" "wheel" ];

    packages = with pkgs; [

    	# dev stuff
	clang
	jdk21
	jdt-language-server
	lua
	lua-language-server
    python3
    python3Packages.pip
    pyright

	#
	eclipses.eclipse-java
	vscodium

	# local apps
	spotify
	vesktop
	ungoogled-chromium
	opencode

	# local

    ];

    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [

     networkmanagerapplet
     vim
     wget
     libsecret
     xdg-utils
     lxappearance
     alacritty
     bluetuith
     bluetui
     playerctl
     pavucontrol
     fastfetch
    tmux
    eza
    fishPlugins.pure
    fishPlugins.grc
    grc

  ];

  fonts.packages = with pkgs; [
  	#default fonts
	noto-fonts
	noto-fonts-cjk-sans
  	noto-fonts-color-emoji
  	liberation_ttf
  	fira-code
  	fira-code-symbols
  	mplus-outline-fonts.githubRelease
  	dina-font
	proggyfonts
	# personal fonts
	iosevka
	nerd-fonts.jetbrains-mono
	nerd-fonts.iosevka-term
];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
    enable = true;
     enableSSHSupport = true;
  };

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };
    config = {
            credential.helper = "libsecret";
    };
    };
  programs.thunar.enable = true;
  programs.neovim = {
	enable = true;
	defaultEditor = true;
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # wifi
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
