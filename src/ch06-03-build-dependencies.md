# Build Dependencies

How to add build dependencies for a packages
- Difference between nativeBuildInputs and buildInputs
- Difference between propagated and non-propagated inputs
- Demonstrate some common usage patterns around dependencies

How do packages find dependencies when building?
- They don't, nix attempts to fulfill assumptions made by the toolchain
  - Generally delegated to tooling which specializes in dependency discovery
    - `PKG_CONFIG_PATH`? for `pkg-config`
    - `CMAKE_MODULE_PATH`? for `cmake`
    - `PYTHONPATH` for `python` when using `buildPythonPackage`
    - etc.

Explain difference between out, dev, lib, and other outputs
- It's a common use case to reference one or more outputs
- Mention the lib's `getDev`, `getDev`, `getLib`, and `getMan` helpers
- TODO: Link to another section expanding on multi-output derivations
