# Imports and callPackage

## Import

`import` is one of the few keywords in nix. It allows for a file to be read and evaluated. If a directory is passed to `import`,
then it will assume `<directory>/default.nix` was the desired file.

```
$ cat data.nix
{ a = "foo"; b = "bar"; }

nix-repl> :p import ./data.nix
{ a = "foo"; b = "bar"; }

$ cat expression.nix
5+2

nix-repl> :p import ./expression.nix
7
```

This still extends to functions:
```
$ cat function.nix
{ x, y }: x + y

nix-repl> :p import ./function.nix { x = 2; y = 9; }
11
```

### Imports for packages

In nixpkgs, each package usually has a corresponding
file associated with the packaging and related concerns of just that package.
Early in nix's history, `import` was used to integrate the files with other expressions and allow for greater organization of code.
However, the import model is quite explicit, and requires users
to declare the dependencies twice.

Below is an example expression for `openssl`:
```
# pkgs/libraries/openssl/default.nix
{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation {
  ...
}
```

In the `import` paradigm, the calling site would look:
```
  openssl = import ../libraries/openssl {
    inherit lib stdenv fetchurl perl;
  };
```

Obviously this isn't ideal. The dependencies need to be referred to
three times, once at the call site, as inputs to the expression,
and then within the expression at the appropriate section.
The tediousness of passing the values will be solved by `callPackage`.

## CallPackage

`callPackage` is a function which will call a function with the
appropriate dependencies. The package set will generally expose
a `callPackage` function with the current package set already bound.

A minimal callPackage implementation can be thought of as:
```
  # <nixpkgs>/lib/customisation.nix
  # callPackageWith :: Attr Set -> (Attr Set -> drv) -> Attr Set -> drv
  callPackageWith = autoArgs: fn: args:
  # autoArgs - Attr set of "defaults", for nixpkgs this would be all top-level packages
  # fn       - A nix expression which uses an attr set as in input.
  # args     - Overrides to the defaults in autoArgs
  let
    # if a file is passed, import it
    f = if lib.isFunction fn then fn else import fn;

    # find what attrs are shared from expression and package set
    # then override the values by anything passed explicitly through args
    fargs = builtins.intersectAttrs (lib.functionArgs f) autoArgs // args;
  in
    f fargs; # With nix, creation of a derivation is just function application
```

Usage of `callPackage` would look something like this:
```
  # <nixpkgs>/pkgs/top-level/all-packages.nix
  { lib, ... }:

  let
    self = with self; {
      ...

      callPackage = lib.callPackageWith self;

      openssl = callPackage ../libraries/openssl { };
    };
  in self
```

With `callPackage` we only need to explicitly pass an attr set
if we need to override the default values that would have been
present in the package set.

In nixpkgs, `callPackage` has been extended to include helpful
package hints, and thus the complexity has grown, but the 
underlying intuition has remained the same.

In javascript, `callPackage` would be an example of a curried function,
where there's an implicit package set bound to it.
