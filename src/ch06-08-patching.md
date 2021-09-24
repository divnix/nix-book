# Patching Packages

- Common scenario where a pull request hasn't been merged or a new release hasn't
been cut, but a change should be applied to a given package.

- Cover `patches` attr for mkDerivation

- Introduce `fetchpatch` utility
  - Show example
  - Make note that fetchpatch does it's own sanitization, meaning that fetchpatch
  and `nix-prefetch-url` will generally create different FODs
  - Make note that generally a comment should be added to explain why a patch is being
  added, and when is it an appropriate time to remove it
