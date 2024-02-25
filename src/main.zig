const std = @import("std");

const enums = @import("enums.zig");
const fileio = @import("fileio.zig");
const httpClient = @import("httpClient.zig");
const httpServer = @import("httpServer.zig");
const json = @import("json.zig");
const thread = @import("thread.zig");
const concurrency = @import("concurrency.zig");

pub fn main() !void {
    try enums.demo();
    try fileio.demo();
    try httpClient.demo();
    try json.demo();
    try thread.demo();
    try concurrency.demo();
    try httpServer.start();
}
