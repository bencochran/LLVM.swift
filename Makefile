all:
	@swift build \
		-Xcc -I`llvm-config --includedir` \
		-Xlinker -L`llvm-config --libdir` \
		-Xlinker -rpath -Xlinker `llvm-config --libdir`
