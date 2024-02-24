const std = @import("std");

fn threadFn(arg: anytype) void {
    const message = arg;
    std.debug.print("Thread: {s}\n", .{message});
}

pub fn demo() !void {
    var thread = try std.Thread.spawn(.{}, threadFn, .{"Hello"});
    defer thread.join();
}
