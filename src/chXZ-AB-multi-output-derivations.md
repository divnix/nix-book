# Multi-Output Derivations

- Explain reasoning behind multiple output derivations
  - Do the expensive build once, but allow for the artifacts to be
  divided between many use-case dependent outputs

- Common outputs that you would see and what should be contained in them:
  - out
  - bin
  - dev
  - lib
  - share
  - man

- Limitations of multiple output derivations:
  - Can't contain circular dependencies between outputs
