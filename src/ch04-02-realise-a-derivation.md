# Realise a derivation

Building a derivation is referred to as "realisation". A derivation is just an abstract
description of a package, based upon what it requires to build. Derivations can be thought
of as constructing a blueprint, but realisation is the construction of the desired object.
Taking from the previous example, one can build a derivations like so:

```
$ nix-store --realise /nix/store/byqskk0549v1zz1b2a61lb7llfn4h5bw-hello-2.10.drv
...
/nix/store/f4bywv8hjwl0ckv7l077pnap81h6qxw4-hello-2.10

# or in nix flakes:

$ nix build nixpkgs#hello
...
/nix/store/f4bywv8hjwl0ckv7l077pnap81h6qxw4-hello-2.10
```

Here, the gnu hello project was built and installed at the output path. This
includes: the executable binary, documenation, and locale info.

```
$ tree -L 2 /nix/store/f4bywv8hjwl0ckv7l077pnap81h6qxw4-hello-2.10
/nix/store/f4bywv8hjwl0ckv7l077pnap81h6qxw4-hello-2.10
├── bin
│   └── hello
└── share
    ├── info
    ├── locale
    └── man
```

The `nix-build` and `nix build` commands will perform both instantiation and realisation. 
These are the most common commands used when iterating on packages. One could also do:

```
$ nix-build '<nixpkgs>' -A hello
# these are the same, nix build is just much more concise
$ nix-store --realise $(nix-instantiate '<nixpkgs>' -A hello)
```

*Note:* Many other commands also will realise a derivation
as part of a workflow. Some examples are:
`nix-shell`, `nix shell`, `nix-env`, `nix run`, and `nix profile`.
These commands are very goal oriented and will differ
significantly in how they leverage nix, often realisation
is an side-effect to achieve that goal.
