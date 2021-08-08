{ stdenv
, nix-gitignore
, mdbook
}:

let
  additionalFilters = [ "*.nix" "nix/" "build/" ];
  filterSource = nix-gitignore.gitignoreSource additionalFilters;
  cleanedSource = filterSource ../.;
in stdenv.mkDerivation {
  pname = "nix-book";
  version = "0.0.1";

  src = cleanedSource;

  nativeBuildInputs = [ mdbook ];
}
