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
$ cat hello.nix
let
  pkgs = import <nixpkgs> { };
in
  pkgs.writeScriptBin "greet.sh" ''
    ${pkgs.hello}/bin/hello -g "Hello $USER!"
  ''

$ nix-build hello.nix
this derivation will be built:
  /nix/store/xd9qpwnvybm9p8k2szhkvpd2ym85is9p-greet.sh.drv
building '/nix/store/xd9qpwnvybm9p8k2szhkvpd2ym85is9p-greet.sh.drv'...
/nix/store/h8yxaciazc8basn9l335bmdrpfak0aqk-greet.sh

$ cat ./result/bin/greet.sh
/nix/store/mg35qkhk7wqbhhykpakds4fsm1riy8ga-hello-2.12.1/bin/hello -g "Hello $USER!"

$ ./result/bin/greet.sh
Hello jon!
```

We created a `greet.sh` script which will greet the user.
Nix first created the "derivation" (build plan) of our script at
`/nix/store/<hash>-greet.sh.drv`, and then realised (built) the derivation as
`/nix/store/<hash>-greet.sh`.
We can see from the contents of the resulting file that
`pkgs.hello` was substituted for the realised output path.
This allows for us to not worry about what the unique name
of the derivation will be, but rather worry about the 
contents post realisation.

Although this may not seem markedly better than other package
management workflows such as: please install these tools, then run
this script. There is quite a lot of benefit to leveraging nix whether
it's to create scripts or build more software:
- Use of exact versions which you control
  - For example, which version of python or node do you have?
- No longer dependent on the state of the consuming system
  - For example, do you have python installed?
- Use of multiple versions of the same software
  - Want to use NodeJS v14 in one script, but NodeJS v16 in another? No problem.

Although many ecosystems will have ecosystem specific solutions to these solutions
(e.g. tox for python, nvm for node), nix provides a universal abstraction for
native dependencies and any downstream dependencies.

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
