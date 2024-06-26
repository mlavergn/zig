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

# setup:
# 	zig init-lib

# Alternatives
# zig build-exe src/main.zig
# zig build-lib src/main.zig
# zig build-obj src/main.zig
build:
	zig build
	./zig-out/bin/demo

clean:
	rm -rf zig-cache zig-out

# eg. apple-m2
cpus:
	clang --print-supported-cpus

# eg. aarch64 (aka arm64)
targets:
	clang --print-targets

# Ref MIPs Linux targets
mips:
	# zig cc -target mips-linux-gnu pcap.c -I libpcap -L libpcap -lpcap
	zig cc -target mips-linux-musl pcap.c -I libpcap -L libpcap -lpcap

# MIPS-LE hardware
mipsle:
	# zig cc -target mipsel-linux-gnu pcap.c -I libpcap -L libpcap -lpcap
	zig cc -target mipsel-linux-musl pcap.c -I libpcap -L libpcap -lpcap

# Ref X86_64 Windows target
windows:
	zig build-exe -target x86_64-windows

ios:
	zig build -Dtarget=aarch64-ios

macos:
	zig build -Dtarget=aarch64-macos

format:
	zig fmt src/*.zig

release:
	# zig build -Doptimize=ReleaseSafe
	zig build -Doptimize=ReleaseFast

run:
	zig run src/main.zig

cocoa:
	zig build --verbose-link --sysroot $(shell xcrun --sdk macosx --show-sdk-path)

test:
	zig test src/main.zig
