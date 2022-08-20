# Building a Nix Package

Building a package for nix can range from trivial to near impossible.
Generally the difference between the two experiences is
determined by how many assumptions the build process makes.
Toolchains which have strong integrity guarantees (e.g. lock files)
, and allow for offline builds are generally more nix compatible.

Nix is language and toolchain agnostic. Support for many
toolchains have been added to nixpkgs, but the nix build
environment is very constrained so many `<toolchain>2nix` tools have
arisen to try and bridge the gap in expectations.
