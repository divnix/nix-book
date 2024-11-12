{
  description = "Nix-Book: The Nix Package Manager";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, utils }:
    let
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin"];
      localOverlay = import ./nix/overlay.nix;
      forSystem = system: rec {
        legacyPackages = import nixpkgs {
          inherit system;
          overlays = [localOverlay];
        };
        packages = utils.lib.flattenTree {
          inherit (legacyPackages) devShell nix-book;
        };
        defaultPackage = packages.nix-book;
        apps.nix-book = utils.lib.mkApp {drv = packages.nix-book;};
        hydraJobs = {inherit (legacyPackages) nix-book;};
        checks = {inherit (legacyPackages) nix-book;};
      };
    in
      utils.lib.eachSystem systems forSystem // { overlay = localOverlay; };
}
