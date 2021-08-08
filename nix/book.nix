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

  buildPhase = "mdbook build";

  installPhase = ''
    mkdir $out
    cp -r book/* $out
  '';
}
