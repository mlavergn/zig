const std = @import("std");

const KB = 1024;
const MB = 1024 * KB;
const GB = 1024 * MB;

pub fn demo() !void {
    // Create an allocator.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var args = std.ArrayList([]const u8).init(allocator);
    defer args.deinit();
    try args.appendSlice(&[_][]const u8{
        "/bin/ls",
        "-al",
        "/",
    });

    const stdout = std.io.getStdOut().writer();
    const output = try run(args.items, allocator);
    try stdout.print("{s}\n", .{output});
}

fn run(argv: []const []const u8, allocator: std.mem.Allocator) ![]u8 {
    var process = std.ChildProcess.init(argv, allocator);
    process.stdin_behavior = .Pipe;
    process.stdout_behavior = .Pipe;
    process.stderr_behavior = .Pipe;
    process.spawn() catch |err| {
        std.debug.print("Spawn failed for {any} {}\n", .{ argv, err });
        return err;
    };

    // eg. Provide input to process
    // process.stdin.?.writer().writeAll("1\n");

    const outtxt = try process.stdout.?.reader().readAllAlloc(allocator, 10 * MB);
    errdefer allocator.free(outtxt);

    const errtxt = try process.stderr.?.reader().readAllAlloc(allocator, 100 * KB);
    errdefer allocator.free(errtxt);
    std.debug.print("stderr: Spawn terminated with stderr {any} {s}\n", .{ argv, errtxt });

    const term = try process.wait();
    switch (term) {
        .Exited => |code| {
            if (code != 0) {
                std.debug.print("Spawn exited with error code {any} {}\n", .{ argv, code });
                return error.CommandFailed;
            }
        },
        else => {
            std.debug.print("Spawn terminated unexpectedly {any} {}\n", .{ argv, term });
            return error.CommandFailed;
        },
    }

    return outtxt;
}
