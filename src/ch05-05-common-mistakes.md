# Common Mistakes

## Functions

The space after `:` is required. Without a space, nix will
parse the value as an url, and represent it as a string

```
nix-repl> :t x: x
a function

nix-repl> :t x:x
a string
```

## Lists

Functions and lists use whitespace to do funcation application,
however, list element delimination takes precedence over function application.

For example, if someone were to try and use optional python
integration on a package, they may write something like:
```nix
  extraPackages = [
    somePackage.override { withPython = true; }
  ];
```

In this example, it's an array of two elements, `somePackage.override` is a function, and the other element
is an attr set. This is more accurately represented as:
```nix
  extraPackages = [
    (somePackage.override) # type: Attr -> drv
    ({ withPython = true; }) # type: Attr
  ];
```

The correct usage of this would be:
```nix
  extraPackages = [
    (somePackage.override { withPython = true; }) # type: drv
  ];
```

