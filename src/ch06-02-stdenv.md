# Stdenv

`stdenv` provides a foundation for building C/C++ software with nixpkgs. It includes, but is not limited to
containing tools such as: a c compiler and related tools, GNU coreutils, GNU awk, GNU sed, findutils, strip, bash, GNUmake, bzip2, gzip,
and many more tools. Stdenv also provides a default "builder.sh" script which will perform the build of a package. The default builder script
is comprised of many smaller "phases" which package maintainers can alter slightly as needed. The goal of `stdenv` is to enable most C/C++ + `Makefile` workflows; in theory, if a software
package has these installation:
```
./configure # configurePhase, optional
make # buildPhase
make install # installPhase
```
Then the only necessary changes for it to work with `stdenv.mkDerivation` would be the inclusion of
`installFlags = [ "PREFIX=$(out)" ];` to communicate where the package should be installed with nix.

## Unique qualities of Nixpkgs' Stdenv

### Wrapped C Compiler

`stdenv` exposes a wrapped compiler to help communicate nix-specific to the compiler without
having to rely on the upstream maintainer to expose such allowances in configuration. For example,
let's assume that a package doesn't officially support MacOS, so all testing and building
occurs with Linux + GCC. Trying to package this for MacOS might be difficult because the logic
may call `gcc` directly, and assume
- Nix differences
  - Wrapped compiler
  - stdenv [shell functions](https://nixos.org/manual/nixpkgs/stable/#ssec-stdenv-functions)
