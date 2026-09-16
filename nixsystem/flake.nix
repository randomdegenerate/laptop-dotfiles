{
  description = "Sandil's configuration flake";

  inputs = {
    #nixpkgs repo
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {self, nixpkgs, ...}@inputs :
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
        inherit system;
        config = {
            allowUnfree = true;
        };
    };

  in
  {
    nixosConfigurations = {
        MikuTeto = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit system; inherit inputs; };

            modules = [
                ./nixos/configuration.nix
            ];
        };
    };

  };
}
