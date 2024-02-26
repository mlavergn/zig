const std = @import("std");

const sqlite = @cImport({
    @cInclude("sqlite3.h");
});

pub fn demo() !void {
    std.debug.print("Version: {}\n", .{sqlite.SQLITE_VERSION_NUMBER});
    var db: ?*sqlite.sqlite3 = undefined;
    var rc: c_int = sqlite.sqlite3_open(":memory:", &db);
    if (rc != sqlite.SQLITE_OK) {
        var errmsg = sqlite.sqlite3_errmsg(db);
        std.debug.print("Error: {*}\n", .{errmsg});
        return;
    }

    var stmt: ?*sqlite.sqlite3_stmt = undefined;
    rc = sqlite.sqlite3_prepare_v2(db, "SELECT 1", -1, &stmt, null);
    while (sqlite.sqlite3_step(stmt) == sqlite.SQLITE_ROW) {
        const colText = sqlite.sqlite3_column_text(stmt, 0);
        std.debug.print("Row: {s}\n", .{colText});
    }

    _ = sqlite.sqlite3_finalize(stmt);
    rc = sqlite.sqlite3_close(db);
}
