const std = @import("std");
const http = @import("http.zig");
const json = @import("json.zig");
const httpServer = @import("httpServer.zig");

pub fn main() !void {
    try http.http_demo();
    try json.json_demo();
    try httpServer.start();
}
