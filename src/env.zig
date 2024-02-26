const std = @import("std");
const builtin = @import("builtin");

pub const log_level: std.log.Level = .info;

pub fn demo() !void {
    // random
    var rand = std.rand.DefaultPrng.init(0);
    // random number between 0 and 10
    var num = @mod(rand.random().int(i32), 10);
    std.debug.print("Random: {}\n", .{num});

    // spawn
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // defer _ = gpa.deinit();
    // const allocator = gpa.allocator();
    // var argv = [_][]const u8{ "/bin/ls", "/var/tmp" };
    // // alt: std.ChildProcess.init(argv, a) catch |err|
    // var result = std.ChildProcess.exec(.{
    //     .argv = &argv,
    //     .allocator = allocator,
    // });
    // std.debug.print("Exec: {!}\n", .{result});

    // ioctls
    // var buf: i32 = 0;
    // const DKIOCEJECT = 0x20006415;
    // const fd = std.os.STDOUT_FILENO;
    // const rc = std.os.system.ioctl(fd, DKIOCEJECT, &buf);
    // const err = std.os.errno(rc);
    // std.debug.print("ioctl: {}{!}\n", .{ buf, err });

    // logging
    const osname = builtin.target.os.tag;
    std.log.info("OS: {}", .{osname});
}
