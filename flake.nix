{
  description = "Nix-book";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, utils }:
    let
      localOverlay = import ./nix/overlay.nix;
      pkgsForSystem = system: import nixpkgs {
        overlays = [
          localOverlay
        ];
        inherit system;
      };
    in utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ] (system: rec {
      legacyPackages = pkgsForSystem system;
      packages = utils.lib.flattenTree {
        inherit (legacyPackages) devShell nix-book;
      };
      defaultPackage = packages.nix-book;
      apps.nix-book = utils.lib.mkApp { drv = packages.nix-book; };
      hydraJobs = { inherit (legacyPackages) nix-book; };
      checks = { inherit (legacyPackages) nix-book; };
  }) // {
    overlay = localOverlay;
  };
}
