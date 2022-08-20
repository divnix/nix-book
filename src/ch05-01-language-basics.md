# Nix Language Basics

## Primitive Values

These values are mostly similar to JSON:

| Type | Description | Example
|---|---|---|
| integer | Whole number | 1 |
| float | Floating point number | 1.054 |
| string | UTF-8 string | "hello!" |
| path | File or url | ./default.nix |

*NOTE*: Paths are special. They will be resolved relative to the file.
They must start with a "." or "/", similar to how they would be expressed in a shell.
If a path is referenced as part of a package, that path will be added to the
nix store, and all references to that path will be substituted with the nix store path.

*NOTE*: If a path to a directory is passed, but a file was expected; then nix will look
for a `default.nix` located in that directory, and will target that.

## Strings

Nix exposes two ways to express strings. Strings are enclosed with double quotes: `"hello"`.
This works well for small strings, such as simple flags. However, it's common to write a
block of commands which need to be executed; for this, nix also has multi-line support with
the "lines" construct. "lines" are denoted by two single quotes.

Example usage of lines:
```
  postPatch = ''
    ./autogen.sh
    mkdir build
    cd build
  '';
```

Here, we have postPatch being assigned a series of commands to be ran as part of a build.


## Lists

Lists work similarly to most other languages, but are whitespace delimited. `[ 1 2 ]` is an
array with elements `1` and `2`.

**Note**: For oddities around lists and elements which use whitespace, please see [list common mistakes](./ch05-05-common-mistakes.html#lists).

## Attribute Set (Attr set)

This can be thought of as a dictionary or map in most other languages. The important distinct is that the
keys are always ordered, so that the order doesn't influence how a derivation will produce a hash. Attr sets
values do not need to be of the same type. Attr sets are constructed using an `=` sign which denotes key value
pairs which are separated with semicolons `;`, the attr set is enclosed with curly braces `{ }`. Selection
of an attribute is done through dot-notation `<set>.<key>`.

```
> a = { foo = "bar"; count = 5; flags = ''-g -O3''; }
> a.count
5
```

You will commonly see empty attr sets in nixpkgs, an example being:
```
  hello = callPackage ../applications/misc/hello { };
```

## Derivations

Technically, a derivation is just an attr set which has a few special attributes
set to valid values which then nix can later realise into a build. Promotion
from an attr set to derivation is facilitated through the `builtins.derivation`
function. However directly calling the builtin is highly discouraged within
nixpkgs. Instead people are encouraged to use stdenv.mkDerivation and other
established builders which provide many good defaults to achieve their packaging goals.

## If / Else logic

Like many other functional programming languages, you cannot
use `if` without an accompanying `else` clause. This is because
the expression needs to return a value, not just follow a code
path.

```
  extension = if stdenv.isDarwin then
      ".dylib"
    else
      ".so";
```

**Note**: The proper way to find the shared library extension
within nixpkgs is `hostPlatform.extensions.sharedLibrary`.

## Let expressions

Let expressions are a way to define values to be used later in a given 'in' scope.
Generally these are used to alter a given value to conform to a
slightly different format. Let expressions can refer
to other values defined in the same let scope. For haskell users,
let expressions work similarly to how they work in Haskell.

```
  src = let
    # e.g. 3.1-2 -> 3_1_2
    srcVersion = lib.strings.replaceStrings [ "." "-" ] [ "_" "_"] version;
    srcUrl = "https://example.com/download/${pname}-${srcVersion}.tar.gz";
  in fetchurl {
    url = srcUrl;
    sha256 = "...";
  };
```
  
## With expressions

With expressions allows for many values on an attr set to be
exposed by their key names.

```
  # before
  meta = {
    licenses = lib.licenses.cc0;
    maintainers = [ lib.maintainers.jane lib.maintainers.joe ];
    platforms = lib.platforms.unix;
  };
```

```
  # after
  meta = with lib; {
    licenses = licenses.cc0;
    maintainers = with maintainers; [ jane joe ];
    platforms = platforms.unix;
  };
```

## Laziness

Many pure functional programming languages also have the feature that the
evaluation model of the language is lazy. This means that the values
of a data structure aren't computed until needed.
The benefits for nix is that evaluating a package doesn't mean computing
all packages, but only computing the dependency graph for the packages
requested. In practice this means limiting the scope of an action from
80,000+ possible dependencies to just the dependencies explicitly mentioned
by the nix expressions.

Although laziness isn't a hard requirement for nix to work. The purity
model of nix makes laziness more a symptom rather than an explicit design goal.
However, It does enable many implicit benefits such as [memoization](https://en.wikipedia.org/wiki/Memoization).

