# Nix Language Basics

## Primitive Values

These mostly similar to JSON:

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

**Note**: Since lists are whitespace delimited, ensure that you encapsulate expressions with `( )`.
A common mistake is doing something like `extraPackages = [ somePackage.override { withPython = true; } ]`.
In this example, it's an array of two elements, `somePackage.override` is a function, and the other element
is an attr set. However, it was likely meant to be a single element array with the attr set applied to function
and creating a new derivation.

## Attribute Set (Attr set)

This can be thought of as a dictionary or map in most other languages. The important distinct is that the
keys are always ordered, so that the order doesn't influence how a derivation will produce a hash. Attr sets
values do not need to be of the same type. Attr sets are constructed using an `=` sign which denotes key value
pairs which are separated with semicolons `;`, the attr set is enclosed with curly braces '{ }'.

```
{ foo = "bar"; count = 5; flags = ''-g -O3''; }
```

You will commonly see empty att sets, and example being:
```
  hello = callPackage ../applications/misc/hello { };
```


- Attr Sets
- If expressions
- Let expressins
- with expressions
- laziness
