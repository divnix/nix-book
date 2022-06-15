# Using Derivations from Nix

The derivation is the main abstraction of nix. All of
Nixpkgs and NixOS is created by leveraging derivations
to create new derivations, scripts, services, and even
entire linux distributions. The ability to compose these
usecases with uniquely named packages allows nix the
freedom to aggressively share common dependencies, meanwhile
allowing the flexibility to have potentially incompatible
packages available on the system.

The nix language allows for consumption of derivations
to be quite transparent. For example:

```
$ nix-build -E 'with import <nixpkgs> { }; pkgs.runCommand "greet.sh" {} "${pkgs.hello}/bin/hello -g \"Hello $USER!\""'
```

Will create a `greet.sh` script which will greet the user.
We can see from the contents of the resulting file that
`pkgs.hello` was substituted for the realised output path.
This allows for us to not worry about what the unique name
of the derivation will be, but rather worry about the 
contents post realisation.

### Use of "outPath" as a toString

This is one of the oddities of nix, but stringification of
an object which contains a key "outPath" will return
the contents of the "outPath" key. Since all derivations
will have an outPath, any usage of them in a string
will yeild the store path that they create.

```nix
nix-repl> a = { outPath = "foo"; }

nix-repl> "${a} bar"
"foo bar"
```

#### If it gets converted to a string, how does nix know how to build the derivation?

Nix has a concept of "contextual strings". Although
the string `/nix/store/f4bywv8hjwl0ckv7l077pnap81h6qxw4-hello-2.10/bin/hello`
is written to the file to create the script; there's still
a "context" from where that path came from. Nix will
also retain this and add as an input to the derivation for
the script. After the package is built, nix will
scan for nix store references, and retain valid
nix store paths as runtime dependencies.
This and other nix behavior will be demonstrated further in later sections.
