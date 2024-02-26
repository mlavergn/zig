const std = @import("std");

const BUF_SIZE = 4096;

pub fn demo() !void {
    // open the file LICENSE
    const file = try std.fs.cwd().openFile("LICENSE", .{});
    defer file.close();

    // setup a buffer and a reader
    var buf: [BUF_SIZE]u8 = undefined;
    const reader = file.reader();

    // read into the buffer
    var n = try reader.read(&buf);
    var result: u64 = 0;
    while (n != 0) {
        result += n;
        // std.debug.print("{s}\n", .{buf});
        n = try reader.read(&buf);
    }

    // write
    // _ = try file.writer().write("blah");

    std.debug.print("\nResult: {}\n", .{result});
}
