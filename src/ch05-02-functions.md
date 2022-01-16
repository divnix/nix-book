# Functions

Nix only has unary functions: functions are only
able to take one parameter. However, in combination with
[uncurrying](https://en.wikipedia.org/wiki/currying), you can
create functions which take an arbitrary number of parameters.

Functions can be treated as values, and freely passed to other
functions as such. To name a function, it just needs to be assigned
to variable, much as you would do to a literal.

Function examples:
```
# creation, and immediate application of a nameless function
nix-repl> (x: x + 2) 3
5

# naming a single parameter function, then later applying it
nix-repl> addTwo = x: x + 2

nix-repl> addTwo 3
5

# two parameters
nix-repl> sumBoth = x: y: x + y

nix-repl> sumBoth 2 5
7
```

## Attr sets as inputs
Nix also heavily uses attr sets to pass around many arguments.
In nixpkgs, this is most commonly used to express what subset of
packages and utilities should be used for a nix expression. It's
also useful when a large context for a function is needed, and
an ordered list of parameters is a poor fit.

Attr sets as inputs are also particular good when the function
can provide good defaults, and only a small subset of inputs are
expected to be edited.

Function examples:
```nix
# function which takes an attr set
nix-repl> addTwo = { x }: x + 2

nix-repl> addTwo { x = 3; }
5

# function which takes optional attr set values
nix-repl> addTwoOptional = { x ? 4 }: x + 2

nix-repl> addTwoOptional { }
6

nix-repl> addTwoOptional { x = 5; }
7

# same as above, but binding the entire attr set to another variable
nix-repl> addTwoOptional = { x ? 4 }@args: args.x + 2

nix-repl> addTwoOptional  { x = 6; }
8
```

**Note**: The `@` syntax is not very common for most nix expressions.
It's most common use case are "helpers", which only care about a
subset of arguments, and will then call another function with some
of the inputs pruned. A good example of this is the `pkgs.fetchFromGithub`
fetcher; which will know how to translate owner, repo, rev, and
other options into a call to `builtsin.fetchzip` or `builtins.fetchgit`.
