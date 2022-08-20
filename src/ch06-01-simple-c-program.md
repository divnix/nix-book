# Simple C program

Many fundamental unix tools are written in C, as it provides many
benefits to system programmers. In this section we will cover
how to compile and package a simple C application to demonstrate
how the nix build process works.

## Impure build and install

Given the example C program:
```
$ cat simple.c
#include <stdio.h>

void main() {
  printf("Hello from Nix!");
}
```

The build and installation of which on a traditional FHS
system may look like:
```
# build
$ gcc simple.c -o hello_nix
# install
$ sudo cp hello_nix /usr/bin/hello_nix
```
However, let's see how this would be done in nix

## Nix build 

Implicit to the previous workflow, was the availability of the GNU C Compiler and
the usage of the `cp` command. In many package repositories, usage of these tools
is near universal; and forms the foundation for how to build most other software.

Although C compilers and GNU's `coreutils` (where `cp` comes from) have their
own specific packages in nixpkgs, generally they are aggregated into a pseudo-package
called `stdenv` in nixpkgs. The function `stdenv.mkDerivation` provides:
- A nixpkgs-compatible wrapped C compiler (GCC on linux, Clang on MacOS)
- GNU coreutils
- A default "builder" script

`stdenv` will be covered in more detail in [the next section](./ch06-02-stdenv.md).

A nixified version of the build would look like:
```
# simple.nix
let
  pkgs = import <nixpkgs> { };
in
  pkgs.stdenv.mkDerivation {
    name = "hello-nix";

    src = ./.;

    # Use $CC as it allows for stdenv to reference the correct C compiler
    buildPhase = ''
      $CC simple.c -o hello_nix
    '';
  }
```

Nix defaults to a Makefile workflow unless specified otherwise.
So stdenv will default to calling `make install` for the `installPhase` which will
fail with `No rule to make target 'install'` so we need
to also fix how nix will install the package.

```
$ nix-build simple.nix
this derivation will be built:
  /nix/store/dbavzdq1idb0hvwdh7r9gfn2l52kvycf-hello-nix.drv
...
install flags: SHELL=/nix/store/3j918i1nbwhby0y38bn2r438rjhh8f4d-bash-5.1-p16/bin/bash install
make: *** No rule to make target 'install'.  Stop.
error: builder for '/nix/store/dbavzdq1idb0hvwdh7r9gfn2l52kvycf-hello-nix.drv' failed with exit code 2;
```

## Nix install

The second glaring problem in the old workflow, is that
we had a convention as to where to install the executable in /usr/bin/.
But installing software in a central location is one the issues that
nix is trying to solve. Instead, nix needs to install files on a per-package
basis, thus where we need to install files will change for every package.
So how do we know where to install files with nix?

Nix will bind the values defined in the derivation to environment variables
inside of the nix build. The default "output" of a package is `out`, which will be bound
to the hashed nix store path mentioned in [the derivation section](./ch04-01-create-a-derivation.md).

So an adjusted workflow would be:
```
# build
$ gcc simple.c -o hello_nix
# install
$ mkdir -p $out/bin
$ cp hello_nix $out/bin/hello_nix
```

Extending the example above, the easiest solution would be to write our own `installPhase`. The
resulting expression would be:

```
# simple.nix
let
  pkgs = import <nixpkgs> { };
in
  pkgs.stdenv.mkDerivation {
    name = "hello-nix";

    src = ./.;

    buildPhase = ''
      $CC simple.c -o hello_nix
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp hello_nix  $out/bin/hello_nix
    '';
  }
```
Now when we build the package, nix is able to realize it. After which we can use the executable:
```
$ nix-build simple.nix
this derivation will be built:
  /nix/store/9j274i4wckn0ksxpj7asd8vbk67kfz4p-hello-nix.drv
...
/nix/store/giwy9rwzwsdvh86pvdpv37lkwms7xcx9-hello-nix

$ ./result/bin/hello_nix
Hello from Nix!
```
