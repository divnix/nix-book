# Create a Derivation

Before a package is built, a derivation must be created. The derivation can
be thought of as the unamiguous definition of how to build a package.
The process of creating a derivation  is called "instantiatiation",
or sometimes also refered to as evaluation (although this is more general). Every package in
nixpkgs has a corresponding derivation. This means that we can
create and inspect the derivation for anything exposed in nixpkgs. An example
would be:

```
$ nix-instantiate '<nixpkgs>' -A hello
/nix/store/byqskk0549v1zz1b2a61lb7llfn4h5bw-hello-2.10.drv

# or using flakes, nix>=2.4

$ nix eval nixpkgs#hello.drvPath
"/nix/store/byqskk0549v1zz1b2a61lb7llfn4h5bw-hello-2.10.drv"
```

## Inspect the contents of a derivation

To inspect the contents of the drv, one can use the `nix show-derivation` utility.

```
$ nix show-derivation /nix/store/byqskk0549v1zz1b2a61lb7llfn4h5bw-hello-2.10.drv
{
  "/nix/store/byqskk0549v1zz1b2a61lb7llfn4h5bw-hello-2.10.drv": {
    "outputs": {
      "out": {
        "path": "/nix/store/f4bywv8hjwl0ckv7l077pnap81h6qxw4-hello-2.10"
      }
...
```

## Defining characteristics of a derivation

There's a few important features of a derivation:
- It's a description of how to build the package from source
- The output paths are determined before the build begins
- All dependencies are resolved as part of instantiation, and may have a similar derivation description of their builds
- Any additional flags (makeFlags, configuration flags, cflags, or ld flags) are explicitly stated
- There's no ambiguity. The system, architecture, and other options have been resolved.
- It's immutable. If you want to change a derivation, you need to evaluate a new one.
- It's unique. The hashing scheme ensures that there should only ever be one derivation; if two derivations match, then they are exactly the same in every way.
