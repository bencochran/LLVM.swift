import PackageDescription

let package = Package(
    name: "LLVM",
    dependencies: [
        .Package(url: "https://github.com/rxwei/LLVM_C", majorVersion: 2, minor: 0),
    ]
)
