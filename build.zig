const std = @import("std");

// const target = std.zig.CrossTarget{ .os_tag = .windows, .cpu_arch = .x86_64 };

pub fn build(b: *std.Build) !void {
    const bin = b.addExecutable(.{
        .name = "demo",
        .root_source_file = .{ .path = "src/main.zig" },
    });

    // Integrate Assembly
    // bin.addAssemblyFile("foo.s");

    // Integrate C code
    // b.addIncludePath(.{ .path = "src" });
    // b.addCSourceFiles(&[_][]const u8{"src/demo.c"}, &[_][]const u8{ "-g", "-O3" });

    // Integrate C libs
    bin.linkSystemLibrary("sqlite3");
    bin.linkLibC();

    // Integrate ObjC framework
    // bin.linkSystemLibrary("objc");
    // bin.addFrameworkPath(.{ .path = "/System/Library/Frameworks" });
    // bin.linkFramework("Foundation");
    // bin.linkFramework("CoreFoundation");

    const install = b.addInstallArtifact(bin, .{});
    install.step.dependOn(&bin.step);

    const install_path = try std.fmt.allocPrint(b.allocator, "{s}", .{b.install_path});
    defer b.allocator.free(install_path);

    b.default_step.dependOn(&install.step);
}
