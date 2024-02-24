const std = @import("std");
const json = @import("json.zig");
const httpClient = @import("httpClient.zig");
const httpServer = @import("httpServer.zig");
const enums = @import("enums.zig");
const thread = @import("thread.zig");
const concurrency = @import("concurrency.zig");

pub fn main() !void {
    try concurrency.demo();
    try thread.demo();
    try enums.demo();
    try json.demo();
    try httpClient.demo();
    try httpServer.start();
}
