const std = @import("std");

const objc = @import("objc.zig");

pub fn main() !void {
    try objc.demo();
}
