# Derivations

Derivations are the defining feature of nix. Derivations attempt to capture everything
that it would take to build a package. This includes, but is not limited to: source code,
dependencies, build flags, build and installation steps, tests, and environment variables.
The culmination of all direct and transitive build depdencies
is commonly refered to as the derivations's "build closure". More dependencies that a
package refers to, more package will need to be created in order to attempt a
build. Generally, dependencies of a derivation are other derivations.

## Types of Derivations

### Fixed Output Derivations (FODs)

These are the "leaves" of any build closure, in that, they do not refer to other
derivations. These derivations are defined by
their content. These derivations are easily differientiated because they
will contain a sha256 (or other hash) which is used to enforce that an artifact
is reproducible.

One critical difference from evaluated derivations is that Fixed-Output derivations
are able to have access to the network while fetching contents. This "impurity"
is offset by enforcing that the hash matches, and reproducibility is delegated to
the process which fetchs the assets.

Many of the `fetch*` utilities in nixpkgs and nix's builtins will create FODs.

### Evaluated Derivations

Evaluation derivations are generally what are referred to when the term derivation is used. These
derivations are defined by all of the dependencies, build phases, and flags
present during a build. Nix captures all of the variables which constitute a
derivation and uses a cryptographic hash to give each derivation a unique name.

### Content-Addressable Derivations (CA Derivations)

**NOTE:** This derivation type is still in an experimental state. And care should be given
to enabling content-addressable derivation on a machine.

TODO: Add section on CA derivations


