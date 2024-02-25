const std = @import("std");

const Sha256 = std.crypto.hash.sha2.Sha256;

pub fn demo() !void {
    var sha256 = Sha256.init(.{});
    sha256.update("Hello");
    sha256.update("World");
    var digest = sha256.finalResult();

    std.debug.print("Result: {s}\n", .{std.fmt.fmtSliceHexLower(&digest)});
}
