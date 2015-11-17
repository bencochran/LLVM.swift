# LLVM.swift

Swift wrapper around LLVM-C.

## Notes / Caveats

* You’ll need to bring your own LLVM. Build it yourself or grab it with `brew
  install llvm`.

* To compile, you’re going to need to set `LLVM_PREFIX` in `LLVM.xcconfig` to
  the prefix used when compiling LLVM (e.g. `/usr/local` or
  `/usr/local/Cellar/llvm/3.6.2` if you used Homebrew).

* Because of limitations of Swift frameworks depending on outside C libraries,
  this includes a copy of the necessary LLVM header files. These were taken from
  LLVM 3.6.2 so it’s likely you’ll run in to troubles if you try to compile this
  with a different version.
