# The Nix Language

Nix is a pure, lazy, functional language which serves a domain-specific language (DSL)
for writing nix derivations and expressions. In general, nix can be thought of as 
JSON with functions. 

The goal of Nix is to facilitate the creation of a derivation. In most situations
nix is given a small amount input and expected to produce a result (usually a derivation).
In the case of nixpkgs, the workflow is generally, "given the user has an x86_64-linux
device and the information held within nixpkgs then the desired package will be
`/nix/store/<some hash>-<package>`. This is also why the word evaluation is used commonly
when refering to nix packages, the nix expression which describes how to build
software can evaluate to it's final reduced state given just a system platform.

