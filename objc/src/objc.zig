const std = @import("std");

const objc = @cImport({
    @cInclude("objc/objc.h");
});

const objcRuntime = @cImport({
    @cInclude("objc/runtime.h");
});

const objcMessage = @cImport({
    @cInclude("objc/message.h");
});

const nsObjcRuntime = @cImport({
    @cInclude("objc/NSObjCRuntime.h");
});

const ns = objc;
const Class = opaque {};
const Sel = opaque {};
const Object = opaque {};

const NSUInteger = c_ulong;

extern fn objc_msgSend(...) void;
extern fn objc_getClass(name: [*:0]const u8) *const Class;
extern fn sel_getUid(name: [*:0]const u8) *const Sel;
extern fn sel_registerName(name: [*:0]const u8) *const Sel;

pub fn demo() !void {
    const objcFn = fn (*const Class, *const Sel, [*:0]const u8) callconv(.C) *const Object;
    // const objcMsg = @intFromPtr(objc_msgSend);
    // const x = @ptrFromInt(objcFn, objcMsg);

    var string = "Hello";

    var class = objc_getClass("NSString");
    var sel = sel_getUid("stringWithUTF8String:");
    var call: u8 = @ptrFromInt(objcFn(class, sel, string));
    // var msg = @intFromPtr(objc_msgSend);

    // Reference call:
    //  var string = @intToPtr(fn (*const Class, *const Sel, [*:0]const u8) callconv(.C) *const Object, @ptrToInt(objc_msgSend))(class, sel, raw_string);

    //  @intFromPtr(objc_msgSend))(class, sel, "hello world");
    _ = (call)(class, sel, string);        
    std.debug.print("{s}\n", .{"YAY"});

    // var allocSel = sel_registerName("alloc");
    // var initSel = sel_registerName("init:");

    std.debug.print("{s}\n", .{string});
}
