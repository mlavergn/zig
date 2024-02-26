###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := build

###############################################

st:
	open -a SourceTree .

open:
	code .

build:
	zig build --verbose-link --sysroot $(shell xcrun --sdk macosx --show-sdk-path)
	./zig-out/bin/demo

ios:
	zig build -Dtarget=aarch64-ios

format:
	zig fmt src/*.zig
