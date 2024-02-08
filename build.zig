const std = @import("std");
const Build = std.Build;

pub fn build(b: *Build) !void {
    const bin = b.addExecutable(.{
        .name = "demo",
        .root_source_file = .{ .path = "src/main.zig" },
    });

    const install = b.addInstallArtifact(bin, .{});
    install.step.dependOn(&bin.step);

    const install_path = try std.fmt.allocPrint(b.allocator, "{s}", .{b.install_path});
    defer b.allocator.free(install_path);

    b.default_step.dependOn(&install.step);
}
