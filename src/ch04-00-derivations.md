# Derivations

Derivations are the defining feature of nix. Derivations attempt to capture everything
that it would take to build a package. This includes, but is not limited to: source code,
dependencies, build flags, build and installation steps, tests, and environment variables.
The culmination of all direct and transitive build dependencies
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

### Input-Addressed Derivations

Input-Addressed derivations are generally what are referred to when the term derivation is used. These
derivations are defined by all of the dependencies, build phases, and flags
present during a build. Nix captures all of the variables which constitute a
derivation and uses a cryptographic hash to give each derivation a unique name.

`stdenv.mkDerivation` and related `build*` helpers will create an input-addressed derivation.

### Content-Addressable Derivations (CA Derivations)

**NOTE**: CA Derivations are still considered experimental at the time of writing

Content-Addressable (CA) derivations are a hybrid of both FOD and IA derivations.
The problem which CA derivations address are rebuilds. In the IA derivation model, a patch
to openssl will cause all downstream packages to rebuild since that derivation will
propagate the patch change across all consumers. Under CA derivations, nix can determine
that a consuming package which was built before the openssl patch has remained unchanged
with the only exception being where openssl is located in the nix store. In this case
the package which uses openssl is "the same" in usage, the only thing which has changed is what
variant of openssl it uses. Nix is then free to assert an equivalence of the
package before and after the openssl patch; thus, it doesn't need to rebuild all packages,
just update the references of openssl.

The name Content-Addressable comes from the fact that the implementation will stub out nix store
paths and use this normalized content to compare against other builds. Now nix can deduplicate
builds which were done previously. In the openssl example, the build of curl will likely be
exactly the same; thus any package which just consumes curl will not have to be rebuilt. Only
the references to the new variant of curl needs to be updated.

CA derivations are an opt-in experimental feature, but don't require the user to alter their
existing workflows.
