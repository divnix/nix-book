# Best Practices

## Avoid excessive `with` usage

Although `with` can be useful in small scopes. Doing something such as
`with pkgs;` is usually discouraged. This is most dramatic with `pkgs`,
in which you will introduce 15,000+ variables into your namespace. Although
you may be aware of what is coming from where when you first write the code,
this implicit context is much harder to re-create each time the expression
is visited in the future. This is compounded with multiple `with` expressions,
 as later `with`'s will shadow previously defined values.

This is not to say that all usage of `with` is discouraged, it's often
encouraged with certain tasks such as defining the `meta` section of
a package; as most attributes of a meta section will be pulling from
`lib`. So a `meta = with lib; { ... }` can dramatically reduce how
many `lib.` need to be explicitly added. Also, it's very common for
NixOS modules to use `with lib;` for the whole file as many of the
module building blocks are exposed through `lib`.

In general, `with` should be scoped as much as possible:
```nix
# good
stdenv.mkDerivation {
  ...
  buildInputs = [ openssl ]
    ++ (with xorg; [ libX11 libX11randar xinput ]);
}

# also good, just repetitive
stdenv.mkDerivation {
  ...
  buildInputs = [ openssl xorg.libX11 xorg.libX11randar xorg.xinput ];
}

# discouraged, now all of xorg is exposed everywhere
with xorg;

stdenv.mkDerivation {
  ...
  buildInputs = [ openssl libX11 libX11randar xinput ];
}
```
