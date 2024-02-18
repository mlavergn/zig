const std = @import("std");
const json = @import("json.zig");
const httpClient = @import("httpClient.zig");
const httpServer = @import("httpServer.zig");

pub fn main() !void {
    try json.demo();
    try httpClient.demo();
    try httpServer.start();
}
