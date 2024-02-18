# Zig

Zig templates and prototypes

## What is Zig

Zig is a high performance C-adjacent language that has no GC, no hidden control flows, and offers first-class cross-compilation. Zig is extremely performant and is significantly faster than even Rust (~50% faster).

Zig can export C ABI compliant interfaces that can be imported into C, C++, Objective-C, Swift, etc.

See: http://ziglang.org

## Allocators

- std.heap.page_allocator: allocates an entire page of memory (x86:4kb / arm64:16kb) [slow]
- std.heap.FixedBufferAllocator: allocate from a fixed size buffer
- std.heap.ArenaAllocator: allocate from a sub-allocator (eg. page) and free all at once
- std.heap.GeneralPurposeAllocator: [priority: safe and faster than page_allocator]
- std.heap.c_allocator: [priority: fastest but no mem safety]

## Syntax

### Functions

Return values throwing denoted by leading '!' on return type
