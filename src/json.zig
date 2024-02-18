const std = @import("std");

pub const Person = struct {
    name: []const u8,
    age: i32,
    is_student: bool,
};

pub fn demo() !void {
    const json_string =
        \\{
        \\  "name": "John Doe",
        \\  "age": 30,
        \\  "is_student": false
        \\}
    ;

    const allocator = std.heap.page_allocator;
    const json_parsed = try std.json.parseFromSlice(Person, allocator, json_string, .{});
    defer json_parsed.deinit();

    const json_value = json_parsed.value;

    std.debug.print("Name: {s}\n", .{json_value.name});
    std.debug.print("Age: {}\n", .{json_value.age});
    std.debug.print("Is Student: {}\n", .{json_value.is_student});
}

test "demo" {
    var x = demo();
    try std.testing.expect(x == 1);
}
