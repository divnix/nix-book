# Runtime Dependencies

- Explain how nix finds runtime dependencies (essentially greps for valid /nix/store/... paths)
  - TODO: link to another section on how to reduce closure sizes
  - TODO: link to another section on how to ensure runtime dependencies are correctly picked up
    - E.g. jar files are compressed, but may reference another package which needs to be present on the host
    - Generally this is done by doing `echo ${dependency} > $out/nix-support`

- How to determine a runtime depdency (e.g. `nix-store -q --requisites`)

- How to wrap programs so that certain dependencies are present on PATH or in other ways

- Mention that patching is sometimes required (e.g. python), as there's not always a
deterministic way to define how a package will be consumed (e.g. python module importing another)
