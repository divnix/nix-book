# Phases

As mentioned in [the stdenv section](./ch06-02-stdenv.md), `stdenv.mkDerivation` provides
a default builder script that is comprised of smaller units of work called "phases". Each phase
handles a specific part of the build process: unpacking source code, configuring the build,
compiling, running tests, and installing the final artifacts.

Understanding phases is crucial to packaging software with nix, as they provide
standardized extension points where package-specific logic can be injected.

## Standard Phases

The standard phases executed by `stdenv.mkDerivation` in order are:

1. **unpackPhase** - Unpacks source archives
2. **patchPhase** - Applies patches to source code
3. **configurePhase** - Runs configuration scripts (e.g., `./configure`)
4. **buildPhase** - Compiles the software (e.g., `make`)
5. **checkPhase** - Runs test suites (e.g., `make check`)
6. **installPhase** - Installs files to `$out` (e.g., `make install`)
7. **fixupPhase** - Post-processes installed files (e.g., stripping binaries)
8. **installCheckPhase** - Runs tests on installed outputs
9. **distPhase** - Creates distribution artifacts (rarely used)

Not all phases run by default. For example, `checkPhase` only runs if `doCheck = true;`
is set, and `installCheckPhase` only runs if `doInstallCheck = true;` is set.

## Customizing Phases

There are several ways to customize the build process by modifying phases:

### Overriding an Entire Phase

You can completely replace a phase by setting the corresponding attribute:

```nix
stdenv.mkDerivation {
  name = "example";
  src = ./.;

  buildPhase = ''
    $CC simple.c -o program
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp program $out/bin/
  '';
}
```

When you override a phase, you are responsible for implementing all the
logic for that phase. The default implementation is no longer used.

### Extending Phases with Hooks

Rather than replacing an entire phase, you can inject additional commands
before or after a phase using pre/post hooks:

```nix
stdenv.mkDerivation {
  name = "example";
  src = ./.;

  # Run before the configure phase
  preConfigure = ''
    ./autogen.sh
  '';

  # Run after the build phase
  postBuild = ''
    echo "Build completed successfully!"
  '';

  # Run after the install phase
  postInstall = ''
    # Remove unnecessary files
    rm -rf $out/share/doc
  '';
}
```

Every phase supports both `pre<Phase>` and `post<Phase>` hooks. This approach
is preferred when you only need to add supplementary steps rather than
completely changing how a phase works.

### Disabling Phases

Some phases can be disabled by setting them to an empty string or by using
control variables:

```nix
stdenv.mkDerivation {
  name = "example";
  src = ./.;

  # Disable the configure phase
  configurePhase = ":"; # ":" is a shell no-op

  # Disable the check phase
  doCheck = false;
}
```

## Common Phase Patterns

### The unpackPhase

By default, `unpackPhase` automatically detects and unpacks common archive formats
(.tar.gz, .tar.bz2, .zip, etc.). The source archive is specified via the `src` attribute.

If you need custom unpacking logic:

```nix
stdenv.mkDerivation {
  name = "example";
  src = fetchurl {
    url = "https://example.com/source.custom";
    sha256 = "...";
  };

  unpackPhase = ''
    runHook preUnpack

    mkdir source
    cd source
    custom-unpack-tool $src

    runHook postUnpack
  '';
}
```

**Note**: `runHook` calls are important to preserve pre/post hook functionality
when overriding phases.

### The patchPhase

The `patchPhase` applies patches specified in the `patches` attribute. See
[the patching section](./ch06-08-patching.md) for more details.

If you need to modify source files before building:

```nix
stdenv.mkDerivation {
  name = "example";
  src = ./.;

  postPatch = ''
    # Fix hardcoded paths
    substituteInPlace Makefile \
      --replace /usr/bin $out/bin
  '';
}
```

### The configurePhase

The default `configurePhase` runs `./configure` with appropriate flags if a
configure script is found. You can customize it with:

```nix
stdenv.mkDerivation {
  name = "example";
  src = ./.;

  # Additional flags for ./configure
  configureFlags = [
    "--enable-feature-x"
    "--disable-feature-y"
  ];

  # Or override entirely
  configurePhase = ''
    runHook preConfigure

    cmake -DCMAKE_INSTALL_PREFIX=$out .

    runHook postConfigure
  '';
}
```

### The buildPhase

The default `buildPhase` runs `make` if a Makefile is present. Common customizations:

```nix
stdenv.mkDerivation {
  name = "example";
  src = ./.;

  # Additional flags for make
  makeFlags = [
    "VERBOSE=1"
    "PREFIX=$(out)"
  ];

  # Set number of parallel jobs
  enableParallelBuilding = true;

  # Or override entirely for non-make builds
  buildPhase = ''
    runHook preBuild

    python setup.py build

    runHook postBuild
  '';
}
```

### The checkPhase

Tests are not run by default. Enable them with:

```nix
stdenv.mkDerivation {
  name = "example";
  src = ./.;

  doCheck = true;

  # The default runs "make check" or "make test"
  # Override if needed:
  checkPhase = ''
    runHook preCheck

    python -m pytest tests/

    runHook postCheck
  '';
}
```

### The installPhase

The default `installPhase` runs `make install`. If the package doesn't support
this, you'll need to implement it manually:

```nix
stdenv.mkDerivation {
  name = "example";
  src = ./.;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp my-program $out/bin/

    mkdir -p $out/share/man/man1
    cp docs/my-program.1 $out/share/man/man1/

    runHook postInstall
  '';
}
```

## Advanced Phase Control

### Running Commands in All Phases

Sometimes you need to ensure certain environment variables or setup occurs
in every phase:

```nix
stdenv.mkDerivation {
  name = "example";
  src = ./.;

  # Set environment variables
  NIX_CFLAGS_COMPILE = "-DSPECIAL_FLAG";

  # Or use setupHook for more complex logic
}
```

### Phase Debugging

When a build fails, it can be helpful to understand which phase failed
and what commands were executed. Nix provides some debugging aids:

```bash
# Build with verbose output
$ nix-build --verbose simple.nix

# Enter a build environment to debug interactively
$ nix-shell simple.nix

# Inside nix-shell, run phases manually:
$ unpackPhase
$ cd $sourceRoot
$ patchPhase
$ configurePhase
$ buildPhase
```

### Skipping Phases

While it's possible to skip phases by setting them to `":"`, it's generally
better to be explicit:

```nix
stdenv.mkDerivation {
  name = "example";
  src = ./.;

  # Preferred way to skip configure
  dontConfigure = true;

  # Preferred way to skip build
  dontBuild = true;

  # Preferred way to skip fixup
  dontFixup = true;
}
```

Alternatively, you can also specify the phase explicitly. However, this practice
is generally frowned upon. 

```nix
stdenv.mkDerivation {
  name = "example";
  src = ./.;

  phases = [ "installPhase" ];

  installPhase = ''
    install -m 755 ./script.sh  $out/bin
  '';
}
```

For trivial builds, generally `pkgs.runCommand` is preferred.
```nix
runCommand "example" { } ''
    install -m 755 ${./script.sh} $out/bin
'';
```


## Best Practices

1. **Use hooks when possible**: Prefer `postPatch`, `preBuild`, etc. over
   completely overriding phases. This preserves default behavior and makes
   your package more maintainable.

2. **Include runHook calls**: When overriding phases, always include
   `runHook pre<Phase>` and `runHook post<Phase>` to preserve extensibility.

3. **Use phase-specific attributes**: Prefer `configureFlags`, `makeFlags`,
   `installTargets` over custom phase implementations when possible.

4. **Keep phases focused**: Each phase should do one thing. Don't put
   build logic in `installPhase` or installation logic in `buildPhase`.

5. **Test your package**: Enable `doCheck = true;` when possible to ensure
   the package builds correctly and passes its test suite.

## Example: Complete Package with Multiple Phase Customizations

Here's a practical example showing multiple phase customizations:

```nix
{ stdenv, fetchFromGitHub, cmake, pkg-config, openssl }:

stdenv.mkDerivation rec {
  pname = "example-tool";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "example";
    repo = "tool";
    rev = "v${version}";
    sha256 = "...";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl ];

  # Patch phase customization
  postPatch = ''
    # Fix hardcoded paths in the source
    substituteInPlace src/config.h \
      --replace /usr/share/example $out/share/example
  '';

  # Configure phase customization
  cmakeFlags = [
    "-DENABLE_TESTS=ON"
    "-DUSE_SYSTEM_OPENSSL=ON"
  ];

  # Build phase customization
  enableParallelBuilding = true;

  preBuild = ''
    # Generate version file
    echo "${version}" > version.txt
  '';

  # Check phase customization. For cmake builds, this will run CTest.
  doCheck = true;

  # Install phase customization
  postInstall = ''
    # Install additional documentation
    mkdir -p $out/share/doc/example-tool
    cp -r docs/* $out/share/doc/example-tool/

    # Remove unnecessary files
    rm -rf $out/share/example/tests
  '';

  meta = {
    description = "An example tool demonstrating phase usage";
    homepage = "https://example.com/tool";
  };
}
```

