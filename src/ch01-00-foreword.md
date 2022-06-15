# Foreword

In recent years, it has become an industry standard to deploy software using
some form of containerization; and while this trend has helped to reduce the
complexity of our deployments by offering process and file isolation at
runtime, it has done virtually nothing to reduce the complexity of building
and maintaining software.

Nix tries to bridge this gap using the same isolation primitizes used by
container technologies to ensure environmental conditions are precisely
mirrored _at build time_.

Thanks to it's powerful expression language, Nix's ability to compose packages
is versatile enough even to provide elegant solutions for generating these same
OCI compliant containers in a totally duplicable fashion.

In fact, a Nix build-recipe, termed a _derivation_, is
nothing more than the input to a function whose output is the artifact it
builds. Same inputs? Same output; regardless of the environment Nix is invoked
in.

These outputs can be anything:
* A traditional software package
* A simple script with pinned dependencies built in
* A shell environment containing the development dependencies of a software project
* An entire operating system — NixOS

The final product is always an immutable and unique hash, which can
be used to compute whether a package even needs building or already exists;
either on the local system, or in a remote cache.

At a high level, Nix allows for decomposing the complexity of software,
configurations, services, and the ecosystems they make up, into small
composable units which may then be reproduced, distributed, ran, or
packaged in a totally consistent manner, completely tailored by the user.
Get ready to rethink the way you think about software distribution and welcome
to the Nix community!

— _Jon Ringer and Tim DeHerrera_
