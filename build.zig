const std = @import("std");

pub fn build(b: *std.Build) !void {
    const bin = b.addExecutable(.{
        .name = "demo",
        .root_source_file = .{ .path = "src/main.zig" },
    });

    // If integrating C code
    // b.addIncludePath(.{ .path = "src" });
    // b.addCSourceFiles(&[_][]const u8{"src/demo.c"}, &[_][]const u8{ "-g", "-O3" });

    const install = b.addInstallArtifact(bin, .{});
    install.step.dependOn(&bin.step);

    const install_path = try std.fmt.allocPrint(b.allocator, "{s}", .{b.install_path});
    defer b.allocator.free(install_path);

    b.default_step.dependOn(&install.step);
}
