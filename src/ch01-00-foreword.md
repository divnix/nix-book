# Foreword

Nix is far more than just another package manager. Based on a rigorous set of
principles, it empowers the user to make changes without fearing a hopelessly
broken system as a result.

Consider a standard Linux workflow. You run your servers on the latest LTS
release of Ubuntu. You run the same versions of the same software for months at
a time, fearing what might happen if you were to do a full system upgrade.

Eventually, an import CVE notice comes up and you're forced to upgrade. You
issue the corresponding `apt` commands, and sure enough, some obscure linked
library issue arises, causing a service startup failure. Due to the imperative
nature of a traditional package manager, the previously working state of your
machine is lost, and the only choice is to hunt down the root cause of the
issue and debug until it's resolved. If your lucky, this will only take a few
hours.

Some might point to container managers like Docker as a potential solution to
this problem, and they can certainly help. But since containers use the same
imperative packaging tools to build images, you've simply pushed the problem
one level deeper. Now you have to worry about what happens when it's time to
upgrade your container, instead of the underlying OS. Not to mention the
overhead of bundling an entire operating system just to run a single
application process.

What if you're application could simply _declare_ all of it's dependencies up
front, and bundle them in an isolated package completely free of interference
from the OS, so that if it runs on your machine, it will run on _any_ machine?
What if this artifact could be uniquely and reliably identified with a simple
hash? Further, what if you could iterate on this package without fear of losing
previously working versions?

Enter Nix. Now you can solve the above scenario in any way that suites your
workflow. Build a Nix package once, and rest assured that it will continue to
build and work just as you expect until it's time to upgrade or change a
dependency. Even when that time comes, rest easy knowing that the previous
version of your package, complete with dependencies, is just a `git checkout`
away, when needed.

Manage an entire environment for your project declaratively using the power of
`nix-shell` to ensure your developers always have the tools they need to be
effective.

Need even more control? Use NixOS and manage your entire operating system
leveraging all the aforementioned benefits of Nix, because after all, it's just
another software package. Perform an upgrade of the system and now it won't
boot? No problem. The previous working state of your machine is a simple boot
entry away.

Need to share software artifacts across a large team? Simply wire up a Nix
cache, and rest easy knowing that if your package passes CI, then it's going to
work for everyone who needs access to it, regardless of OS or archtitecture.

Need to declaratively manage your services and containers? Build truly
reproducible Docker or OCI compliant containers using Nix's powerful
integration.

We've tried managing software dependencies in a shared, stateful environment
for generations. We know the pain this causes. We can keep building better
band-aids, or we can use a system that attempts to solve these problems at
their root, and in this author's humble opinion, wildly suceeds. Get ready
to change the way you think about software distribution and welcome to the
Nix community!
