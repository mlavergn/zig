const std = @import("std");
const json = @import("json.zig");
const httpClient = @import("httpClient.zig");
const httpServer = @import("httpServer.zig");
const enums = @import("enums.zig");

pub fn main() !void {
    try enums.demo();
    try json.demo();
    try httpClient.demo();
    try httpServer.start();
}
