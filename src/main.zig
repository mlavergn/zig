const std = @import("std");
const http = @import("http.zig");
const json = @import("json.zig");

pub fn main() !void {
    try http.http_demo();
    try json.json_demo();
}