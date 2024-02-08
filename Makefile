###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := run

###############################################

open:
	code .

setup:
	zig init-lib

build:
	zig build
	./zig-out/bin/demo

# Ref MIPs Linux targets
mips:
	zig cc -target mips-linux-gnu pcap.c -I libpcap -L libpcap -lpcap
	zig cc -target mips-linux-musl pcap.c -I libpcap -L libpcap -lpcap

# Ref X86_64 Windows target
windows:
	zig build-exe -target x86_64-windows

ios:
	zig build -Dtarget=aarch64-ios

release:
	# zig build -Doptimize=ReleaseSafe
	zig build -Doptimize=ReleaseFast

run:
	zig run src/main.zig

test:
	zig test src/main.zig
