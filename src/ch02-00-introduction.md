# Introduction

# The Nix Package Manager

Nix is a package manager which focuses on
caputuring all inputs which contribute to building software.
The result of factoring all of the information about building
the software is called a derivation. This aggregated information includes where
the source code is pulled, configuration flags, patches,
dependencies, build steps, installation steps, and many other potential inputs.

This information is aggregated through hashing, and allows nix to
describe and reference the exact software which is intended to use.
This enables nix to be used on any system because it's assumptions
do not collide with the assumptions of a host system. This also means that
nix does not adhere to the traditional [File Hierarchical System(FHS)](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)
but it also means that it's not limited to FHS's restriction of only having
a single variant of a piece of software.

# The Nix Ecosystem

There's roughly four layers of abstractions in the official nix ecosystem, these are:

- Nix - The domain-specifc language used to write nix expressions
- Nix - The package manager
- Nixpkgs - The package repository
- NixOS - A linux distribution built upon nixpkgs

All of these topic will be discussed in greater detail in later sections, but a 
quick summary is provided below.

## The Nix Language

The Nix language is a Domain-Specific Language (DSL) which is designed to
handle package configuration. Nix can be thought of [JSON](https://en.wikipedia.org/wiki/JSON) + functions +
some syntax sugar. It's main goal is to provide effect-free evaluation of
package configuration, to this point Nix is restricted in many ways and lacks
many features from generic programming languages. There is very limited input and
output possible to the system, there are no loops, no concurrency primitives, and
no types. What is left is a small functional-oriented programming language. After all,
Nix's goal is to take a few inputs such as a system platform, and produce a build
graph which can be used to build software.

## Nix the Package Manager

The Nix Package Manager began it's life as the [PhD thesis work](https://edolstra.github.io/pubs/phd-thesis.pdf)
of Eelco Dolstra. The goal was to bring discipline to the software landscape. Similar to
how structured programming helped tame the complexity of goto through introducing constructs such
as loops and logic flow; so too does nix attempt to tame the chaos of package management
through explicit descriptions of software and their dependencies. The truely novel idea
of Nix is that of the *derivation*. It encapsulates everything about a piece of software,
and these derivations can be referenced from other derivations constituting a Directed-Acyclic-Graph
of how to built that software from source.

## Nixpkgs

Nixpkgs is the official package repository for the Nix community. It contains the logic
on how to build over 60,000+ software packages. Nixpkgs can be thought of as an
expert body-of-knowledge on the subject of how to build software. When a user
asks for the "firefox" package, the nix package manager is able to input the user's computer
platform into nixpkgs, and nixpkgs is then able to produce a build graph on
how to build firefox and all of it's dependencies down to the C compiler.
This allows for a great deal of freedom in how nix is leveraged, and nix can be used on any Linux distribution and MacOS as
first class supported OS's, and to a much lesser degree on many other UNIX-like OS's.

## NixOS

NixOS is a non-FHS Linux distribution which leverages nixpkgs to provide a wealth
of software ready to be combined into a system environment. The concept of a nix
derivation is extended here to include service configuration and system creation.
The entirity of the system is represented as a derivation which gives it many of
it's defining qualities such as atomic rollbacks, system-as-a-configuration-file,
extensive user configuration potential.
