const std = @import("std");
const log = std.log.scoped(.server);

const server_addr = "127.0.0.1";
const server_port = 8000;

// Run the server and handle incoming requests.
fn runServer(listener: *std.net.Server, allocator: std.mem.Allocator) !void {
    accept: while (true) {
        // Accept incoming connection.
        const connection = try listener.accept();
        defer connection.stream.close();

        // Avoid Nagle's algorithm.
        // <https://en.wikipedia.org/wiki/Nagle%27s_algorithm>
        // https://github.com/apple/darwin-xnu/blob/main/bsd/netinet/tcp.h
        const TCP_NODELAY = 0x01;
        try std.posix.setsockopt(
            connection.stream.handle,
            std.posix.IPPROTO.TCP,
            TCP_NODELAY,
            &std.mem.toBytes(@as(c_int, 1)),
        );

        var read_buffer: [1024]u8 = undefined;
        var server = std.http.Server.init(connection, &read_buffer);
        while (server.state == .ready) {
            // Parse the request.
            var request = server.receiveHead() catch |err| switch (err) {
                error.HttpConnectionClosing => continue :accept,
                else => |e| return e,
            };

            // Process the request.
            try handleRequest(&request, allocator);
        }
    }
}

// Handle an individual request.
fn handleRequest(request: *std.http.Server.Request, allocator: std.mem.Allocator) !void {
    // Log the request details.
    log.info("{s} {s} {s}", .{ @tagName(request.head.method), @tagName(request.head.version), request.head.target });

    // Read the request body.
    const body = try (try request.reader()).readAllAlloc(allocator, 8192);
    defer allocator.free(body);

    // Check if the request target starts with "/get".
    const isMethodGet = std.mem.startsWith(u8, request.head.target, "/get");

    if (isMethodGet) {
        // Check if the request target contains "?chunked".
        const isChunkedEncoding = std.mem.indexOf(u8, request.head.target, "?chunked") != null;

        // Write the response body.
        if (request.head.method != .HEAD) {
            var send_buffer: [100]u8 = undefined;
            var response = request.respondStreaming(.{
                .send_buffer = &send_buffer,
                .content_length = if (isChunkedEncoding) 14 else null,
                .respond_options = .{
                    .extra_headers = &.{
                        .{ .name = "content-type", .value = "text/plain" },
                        .{ .name = "connection", .value = if (request.head.keep_alive) "keep-alive" else "" },
                        .{ .name = "transfer-encoding", .value = "chunked" },
                    },
                },
            });

            const w = response.writer();
            try w.writeAll("Zig Bits!\n");
            try response.end();
        }
    } else {
        // Set the response status to 404 (not found).
        try request.respond("Not Found\n", .{ .status = .not_found, .extra_headers = &.{
            .{ .name = "content-type", .value = "text/plain" },
        } });
    }
}

pub fn start() !void {
    // Create an allocator.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // Initialize the server.
    const address = std.net.Address.parseIp(server_addr, server_port) catch unreachable;
    var server = try address.listen(.{
        .reuse_address = true,
    });
    defer server.deinit();

    // Log the server address and port.
    log.info("Server is running at {s}:{d}", .{ server_addr, server_port });

    // Run the server.
    runServer(&server, allocator) catch |err| {
        // Handle server errors.
        log.err("server error: {}\n", .{err});
        if (@errorReturnTrace()) |trace| {
            std.debug.dumpStackTrace(trace.*);
        }
        std.posix.exit(1);
    };
}
