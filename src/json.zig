const std = @import("std");
const json = std.json;

// Allocators
// - std.heap.page_allocator: allocates an entire page of memory (x86:4kb / arm64:16kb)
// - std.heap.FixedBufferAllocator: allocate from a fixed size buffer
// - std.heap.ArenaAllocator: allocate from a sub-allocator (eg. page) and free all at once
//  

// Functions
// - return values: throwing denoted by leading '!' on return type

pub const Person = struct {
    name: []const u8,
    age: i32,
    is_student: bool,
};

fn demo() i32 {
    const result = 1;
    std.debug.print("Hello {}\n", .{result});
    return result;
}

pub fn json_demo() !void {
    const json_string =
        \\{
        \\  "name": "John Doe",
        \\  "age": 30,
        \\  "is_student": false
        \\}
    ;

    const allocator = std.heap.page_allocator;
    const json_parsed = try json.parseFromSlice(Person, allocator, json_string, .{});
    defer json_parsed.deinit();

    const json_value = json_parsed.value;

    // std.debug.print("JSON: {s}\n", .{json_string});
    // std.debug.print("JSON: {}\n", .{json_parsed.value});

    std.debug.print("Name: {s}\n", .{json_value.name});
    std.debug.print("Age: {}\n", .{json_value.age});
    std.debug.print("Is Student: {}\n", .{json_value.is_student});
}

test "demo" {
    var x = demo();
    try std.testing.expect(x == 1);
}