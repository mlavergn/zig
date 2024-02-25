const std = @import("std");

fn performTask(arg: u32) u32 {
    std.debug.print("Starting task {}\n", .{arg});
    async std.time.sleep(std.time.ns_per_ms * 100);
    std.debug.print("Finished task {}\n", .{arg});
    return 123;
}

pub fn demo() !void {
    // Async / Await is expected in 0.12.0
    if (@hasDecl(std, "async")) {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = &gpa.allocator();

        // Require an event loop to run async functions
        const eventLoop = std.event.Loop.init(allocator);
        defer eventLoop.deinit();

        const task = async performTask(1);
        const result = await eventLoop.run(task);

        std.debug.print("Result: {}\n", .{result});
    }
}
