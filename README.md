# LLVM.swift

Swift wrapper around LLVM-C. Tested with LLVM 3.9.0.

## Notes / Caveats

* You’ll need to bring your own LLVM. Build it yourself or grab it with `brew
  install llvm`.

* To compile, you’re going to need to pass the paths to the LLVM headers and
  libraries to `swift build`. There's a `Makefile` in the root directory that
  does this for you, provided you have the `llvm-config` executable in your
  `PATH`. If you do, simply run `make` to build the project.
