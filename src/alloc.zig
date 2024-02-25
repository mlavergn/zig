const std = @import("std");

pub fn demo() !void {
    // std.heap.GeneralPurposeAllocator // most common allocator
    // std.testing.allocator            // test allocator that reports memory leaks

    // std.heap.ArenaAllocator          // alloc from a child allocator + single free
    // std.heap.FixedBufferAllocator    // alloc from a fixed buffer (no free)
    // std.heap.HeapAllocator           // allocator within GeneralPurposeAllocator
    // std.heap.PageAllocator           // allocate a full page of memory (4kb)

    // std.heap.SbrkAllocator           // kernel allocator (don't use this)

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const result = try std.fmt.allocPrint(allocator, "{s},{s},{s}", .{ "abc", "def", "ghi" });
    defer allocator.free(result);

    std.debug.print("Result: {s}\n", .{result});
}
