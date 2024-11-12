# Introduction

# The Nix Package Manager

Nix is a package manager that focuses on
capturing all inputs which contribute to building software.
The result of factoring all of the information about building
the software is called a *derivation*. This information includes from where
the source code is downloaded, configuration flags, patches,
dependencies, build steps, installation steps, and many other potential inputs.

This information is hashed, which allows Nix to
describe and reference the exact software which is intended to use.
This enables Nix to be used on any system because its assumptions
do not collide with the assumptions of a host system. This means that
Nix does not adhere to the traditional [File Hierarchical System (FHS)][fhs]
but it also means that it's not limited to FHS's restriction of only having
a single variant of a piece of software: You can have multiple versions of
the same software installed, or the same version installed twice compiled with
two different set of compile flags without conflict.

[fhs]: https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard

# Who is Nix For

## Teams of Developers

Each developer on a team needs access to the same development environment.

Development environments need to reflect the build and production environments.

When these diverge, software may fail to build or run properly after a software delivery was made.
Having divergent development, build and production environments is a major cause of regressions
in software development. Nix can help mitigate this by allowing environments to be version
controlled and maintained along with a project. Nix can also lower the onboarding time of new
developers by automating installation instructions.

## DevOps

Nix allows you to precisely describe the software you intend to use. Nix packages
are defined by their dependencies, so they inherently retain their SBOM (Software Bill of Materials)
by default. By leveraging NixOS modules, one can also create configurable services and compose
them into coherent systems. The combination of Nix + NixOS allows you to have declarative configuration
of both services and systems of multiple machines and architectures.

## System Administrators (home to enterprise)

Nix allows you to maintain dozens to hundreds of systems: Placing a system's configuration as code
in version control enables a new paradigm of system configuration management. Atomically apply or
rollback system updates for each system. Nixpkgs can be freely extended to include private additions
to software.

Nix largely replaces the need for Docker. However, Nix can also be used to produce Docker images
if there is a downstream technology which consumes OCI images as an interface (e.g. Kubernetes).

## Power Users

Nix allows for incredibly specific or opinionated environments. Nix allows you to declare projects
(flakes), user directory configuration ([home-manager][hm]), or system environments (NixOS) with the exact
same software. Whether you're a software developer, or you're tweaking the appearance of your desktop
system, Nix will allow you to control and specify configuration exactly as you intend, and persist
this across multiple machines.

[hm]: https://github.com/nix-community/home-manager

# The Nix Ecosystem

There's roughly four layers of abstractions in the official Nix ecosystem, these are:

- Nix - The domain-specifc language used to write Nix expressions
- Nix - The package manager
- Nixpkgs - The official Nix package repository
- NixOS - A Linux distribution built on Nixpkgs

There are also a several unofficial projects commonly used within the community. Some of these are:

- [home-manager][hm] - NixOS-like user configuration for Linux or MacOS built on Nixpkgs
- [Nix-darwin](https://github.com/LnL7/nix-darwin) - NixOS-like configuration, but for MacOS

These topics will be discussed in greater detail in later sections, but a
quick summary of official projects are provided below.

## Nix: The Language

The Nix language is a Domain-Specific Language (DSL) which is designed to
handle package configuration. Nix can be thought of [JSON](https://en.wikipedia.org/wiki/JSON) +
functions + imports + some syntax sugar. Its main goal is to provide *effect-free evaluation* of
package configuration. For that reason, Nix is restricted in many ways and lacks
many features from generic programming languages. There is very limited input and
output possible to the system, there are no loops, no concurrency primitives, and
no types. What is left is a small functional programming language. After all,
Nix's goal is to take a few inputs such as a system platform, and produce a build
graph which can be used as a recipe to build software.

## Nix: The Package Manager

The Nix Package Manager began its life as the [PhD thesis work](https://edolstra.github.io/pubs/phd-thesis.pdf)
of Eelco Dolstra. The goal was to bring discipline to the software landscape. Similar to
how structured programming helped tame the complexity of goto through introducing constructs such
as loops and logic flow; so too does Nix attempt to tame the chaos of package management
through explicit descriptions of software and their dependencies. The truly novel idea
of Nix is that of the *derivation*. It encapsulates everything about a piece of software,
and these derivations can be referenced from other derivations constituting a *directed, acyclic
graph* (DAG) of how to built that software from source.

## Nixpkgs: The Package Repository

Nixpkgs is the official package repository for the Nix community. It contains the logic
on how to build over 60,000+ software packages. Nixpkgs can be thought of as an
expert body-of-knowledge on the subject of how to build software. When a user
asks for the "firefox" package, the Nix package manager is able to query Nixpkgs
and produce a build graph on how to build Firefox and all of its dependencies down
to the C compiler, for that user's platform.
This allows for a great deal of freedom: Nix can be used on any Linux distribution and MacOS as
first class supported OS'es, and to a lesser degree on many other UNIX-like OS'es.

Nixpkgs is also supported by [Hydra](https://hydra.nixos.org/), which provides
pre-built binaries of libre software for Linux and MacOS.

## NixOS: The Operating System

NixOS is a [non-FHS][fhs] Linux distribution which leverages Nixpkgs to provide a wealth
of software ready to be combined into a system environment. The concept of a Nix
derivation is extended here to include service configuration and system creation.
The entirety of the system is represented as a derivation which gives it many of
its defining qualities such as atomic rollbacks, system-as-a-configuration-file, and
extensive user configuration potential.
