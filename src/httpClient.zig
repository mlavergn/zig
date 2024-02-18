const std = @import("std");

pub fn demo() !void {
    // Create an allocator.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    // Parse the URI.
    const uri = std.Uri.parse("https://mlavergn.github.io/demo/db.json") catch unreachable;

    // Create the headers that will be sent to the server.
    var headers = std.http.Headers{ .allocator = allocator };
    defer headers.deinit();

    try headers.append("accept", "*/*");
    try headers.append("connection", "keep-alive");

    // Make the connection to the server.
    var request = try client.request(.GET, uri, headers, .{});
    defer request.deinit();

    // Send the request and headers to the server.
    try request.start();

    // Wait for the server to send use a response
    try request.wait();

    // Read the entire response body, but only allow it to allocate 8KB of memory.
    const body = request.reader().readAllAlloc(allocator, 8192) catch unreachable;
    defer allocator.free(body);

    // Print out the response.
    std.debug.print("{s}\n", .{ body });
}
