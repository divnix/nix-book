final: prev: {
  nix-book = prev.callPackage ./book.nix { };

  devShell = final.nix-book;
}
