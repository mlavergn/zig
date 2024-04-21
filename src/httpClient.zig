const std = @import("std");

pub fn demo() !void {
    // Create an allocator.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    // Parse the URI.
    const uri = std.Uri.parse("https://mlavergn.github.io/demo/db.json") catch unreachable;

    // Make the connection to the server.
    var server_header_buffer: [1024]u8 = undefined;
    var request = try client.open(.GET, uri, .{ .server_header_buffer = &server_header_buffer, .extra_headers = &.{
        .{ .name = "accept", .value = "*/*" },
        .{ .name = "connection", .value = "keep-alive" },
    } });
    defer request.deinit();

    // Send the request and headers to the server.
    try request.send();
    try request.finish();

    // Wait for the server to send use a response
    try request.wait();

    // Read the entire response body, but only allow it to allocate 8KB of memory.
    const body = request.reader().readAllAlloc(allocator, 8192) catch unreachable;
    defer allocator.free(body);

    // Print out the response.
    std.debug.print("{s}\n", .{body});
}
